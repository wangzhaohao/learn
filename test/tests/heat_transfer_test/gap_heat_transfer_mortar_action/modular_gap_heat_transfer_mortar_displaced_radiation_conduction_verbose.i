[GlobalParams]
  displacements = 'disp_x disp_y'
[]

[Mesh]
  [file]
    type = FileMeshGenerator
    file = 2blk-gap.e
  []
  [secondary]
    type = LowerDBlockFromSidesetGenerator
    sidesets = '101'
    new_block_id = 10001
    new_block_name = 'secondary_lower'
    input = file
  []
  [primary]
    type = LowerDBlockFromSidesetGenerator
    sidesets = '100'
    new_block_id = 10000
    new_block_name = 'primary_lower'
    input = secondary
  []
  allow_renumbering = false
[]

[Problem]
  kernel_coverage_check = false
  material_coverage_check = false
[]

[Variables]
  [temp]
    order = FIRST
    family = LAGRANGE
    block = '1 2'
  []
  [disp_x]
    order = FIRST
    family = LAGRANGE
    block = '1 2'
  []
  [disp_y]
    order = FIRST
    family = LAGRANGE
    block = '1 2'
  []
  [lm]
    order = FIRST
    family = LAGRANGE
    block = 'secondary_lower'
  []
[]

[Materials]
  [left]
    type = ADHeatConductionMaterial
    block = 1
    thermal_conductivity = 0.01
    specific_heat = 1
  []

  [right]
    type = ADHeatConductionMaterial
    block = 2
    thermal_conductivity = 0.005
    specific_heat = 1
  []
[]

[Kernels]
  [hc_displaced_block]
    type = ADHeatConduction
    variable = temp
    use_displaced_mesh = true
    block = '1'
  []
  [hc_undisplaced_block]
    type = ADHeatConduction
    variable = temp
    use_displaced_mesh = false
    block = '2'
  []
  [disp_x]
    type = Diffusion
    variable = disp_x
    block = '1 2'
  []
  [disp_y]
    type = Diffusion
    variable = disp_y
    block = '1 2'
  []
[]

[UserObjects]
  [radiation]
    type = GapFluxModelRadiation
    temperature = temp
    boundary = 100
    primary_emissivity = 1.0
    secondary_emissivity = 1.0
    use_displaced_mesh = true
  []
  [conduction]
    type = GapFluxModelConduction
    temperature = temp
    boundary = 100
    gap_conductivity = 0.02
    use_displaced_mesh = true
  []
[]

[Constraints]
  [ced]
    type = ModularGapConductanceConstraint
    variable = lm
    secondary_variable = temp
    use_displaced_mesh = true
    primary_boundary = 100
    primary_subdomain = 10000
    secondary_boundary = 101
    secondary_subdomain = 10001
    # 默认是false,设置为true是考虑边缘效应，测试结果表明在这个例子里面没有影响
    correct_edge_dropping = false # true
    gap_flux_models = 'radiation conduction'
  []
[]

[BCs]
  [left]
    type = DirichletBC
    variable = temp
    boundary = 'left'
    value = 100
  []

  [right]
    type = DirichletBC
    variable = temp
    boundary = 'right'
    value = 0
  []

  [left_disp_x]
    type = DirichletBC
    preset = false
    variable = disp_x
    boundary = 'left'
    value = .1
  []
  [right_disp_x]
    type = DirichletBC
    preset = false
    variable = disp_x
    boundary = 'right'
    value = 0
  []
  [bottom_disp_y]
    type = DirichletBC
    preset = false
    variable = disp_y
    boundary = 'bottom'
    value = 0
  []
[]

[Preconditioning]
  [fmp]
    type = SMP
    full = true
    solve_type = 'NEWTON'
  []
[]

[Executioner]
  type = Steady
  nl_rel_tol = 1e-11
  nl_abs_tol = 1.0e-10
[]

[VectorPostprocessors]
  [NodalTemperature]
    type = NodalValueSampler
    sort_by = id
    boundary = '100 101'
    variable = 'temp'
  []
[]

[Outputs]
  csv = true
  [exodus]
    type = Exodus
    show = 'temp'
  []
[]
