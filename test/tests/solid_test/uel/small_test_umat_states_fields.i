[GlobalParams]
  displacements = 'disp_x disp_y'
[]

[Mesh]
  [gen]
    type = GeneratedMeshGenerator
    dim = 2
    nx = 20
    ny = 10
    xmax = 10
    ymax = 3
    elem_type = TRI3
  []
  [pin]
    type = ExtraNodesetGenerator
    nodes = 106
    new_boundary = pin
    input = gen
  []
  displacements = 'disp_x disp_y'
[]

[AuxVariables]
  [temperature]
    initial_condition = 1500
  []
  [voltage]
    initial_condition = 210
  []
[]

[AuxKernels]
  [temperature]
    type = FunctionAux
    function = temperature_function
    variable = temperature
  []
  [voltage]
    type = FunctionAux
    function = voltage_function
    variable = voltage
  []
[]

[Functions]
  [voltage_function]
    type = PiecewiseLinear
    x = '0 15'
    y = '210 450'
  []
  [temperature_function]
    type = PiecewiseLinear
    x = '0 15'
    y = '1500 800'
  []
[]

[BCs]
  [left_x]
    type = DirichletBC
    variable = disp_x
    boundary = left
    value = 0
  []
  [left_y]
    type = DirichletBC
    variable = disp_y
    boundary = pin
    value = 0
  []

  inactive = 'right_dirichlet'
  [right_neumann]
    type = FunctionNeumannBC
    variable = disp_x
    function = t
    boundary = right
  []
  [right_dirichlet]
    type = FunctionDirichletBC
    variable = disp_x
    function = t/10
    boundary = right
  []
[]

[Physics/SolidMechanics/QuasiStatic]
  [all]
    add_variables = true
    strain = SMALL
    incremental = true
    extra_vector_tags = 'kernel_residual'
  []
[]

[Materials]
  [umat]
    type = AbaqusUMATStress
    constant_properties = '100 0.3'
    plugin = '../../plugins/small_elastic_tri_states'
    num_state_vars = 2
    use_one_based_indexing = false
    temperature = 'temperature'
    external_fields = 'voltage'
  []
[]

[Problem]
  kernel_coverage_check = false
  extra_tag_vectors = 'kernel_residual'
[]

[AuxVariables]
  [res_x]
  []
  [res_y]
  []
[]

[AuxKernels]
  [res_x]
    type = TagVectorAux
    variable = res_x
    v = disp_x
    vector_tag = kernel_residual
  []
  [res_y]
    type = TagVectorAux
    variable = res_y
    v = disp_y
    vector_tag = kernel_residual
  []
[]

[Executioner]
  type = Transient
  solve_type = NEWTON
  petsc_options_iname = '-pc_type'
  petsc_options_value = 'lu'
  dt = 1
  num_steps = 15
[]

[Postprocessors]
  [delta_l]
    type = SideAverageValue
    variable = disp_x
    boundary = right
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [V]
    type = ElementIntegralMaterialProperty
    mat_prop = 1
    use_displaced_mesh = true
    execute_on = 'INITIAL TIMESTEP_END'
  []
[]

[Outputs]
  exodus = true
  csv = true
[]
