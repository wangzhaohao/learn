# This is a test designed to evaluate the cabability of the
# IterationAdaptiveDT TimeStepper to adjust time step size according to
# a function.  For example, if the power input function for a BISON
# simulation rapidly increases or decreases, the IterationAdaptiveDT
# TimeStepper should take time steps small enough to capture the
# oscillation.
# 变化的温度步长，用于产生足够小的步长进而捕获振荡

[GlobalParams]
  order = FIRST
  family = LAGRANGE
  block = 1
  displacements = 'disp_x disp_y disp_z'
[]

[Mesh]
  # 0.01m的正方体，上顶是1,底面是2
  file = 1hex8_10mm_cube.e
[]

[Functions]
  [./Fiss_Function]
    type = PiecewiseLinear
    x = '0 1e6  2e6  2.001e6 2.002e6'
    y = '0 3e8  3e8  12e8    0'
  [../]
[]

[Variables]
  [./disp_x]
  [../]

  [./disp_y]
  [../]

  [./disp_z]
  [../]

  [./temp]
    initial_condition = 300.0
  [../]
[]

[Modules/TensorMechanics/Master]
  [./all]
    strain = FINITE
    incremental = true
    volumetric_locking_correction = true
    eigenstrain_names = thermal_expansion
    # 计算有限应变和旋转增量的计算方法， 默认是TaylorExpansion
    decomposition_method = EigenSolution
    add_variables  = true
    generate_output = 'vonmises_stress'
    temperature = temp
  [../]
[]

[Kernels]
  [./heat]
    type = HeatConduction
    variable = temp
  [../]

  [./heat_ie]
    type = HeatConductionTimeDerivative
    variable = temp
  [../]

  [./heat_source]
     type = HeatSource
     variable = temp
     value = 1.0
     function = Fiss_Function
  [../]
[]

[BCs]
 [./bottom_temp]
   type = DirichletBC
   variable = temp
   boundary = 1
   value = 300
 [../]
 [./top_bottom_disp_x]
   type = DirichletBC
   variable = disp_x
   boundary = '1'
   value = 0
 [../]
 [./top_bottom_disp_y]
   type = DirichletBC
   variable = disp_y
   boundary = '1'
   value = 0
 [../]
 [./top_bottom_disp_z]
   type = DirichletBC
   variable = disp_z
   boundary = '1'
   value = 0
 [../]
[]

[Materials]
 [./thermal]
    type = HeatConductionMaterial
    temp = temp
    specific_heat = 1.0
    thermal_conductivity = 1.0
  [../]

  [./elasticity_tensor]
    type = ComputeIsotropicElasticityTensor
    youngs_modulus = 300e6
    poissons_ratio = .3
  [../]

  [./stress]
    type = ComputeFiniteStrainElasticStress
  [../]

  [./thermal_expansion]
    type = ComputeThermalExpansionEigenstrain
    thermal_expansion_coeff = 5e-6
    stress_free_temperature = 300.0
    temperature = temp
    eigenstrain_name = thermal_expansion
  [../]

  [./density]
    type = Density
    density = 10963.0
  [../]
[]

[Executioner]
  type = Transient
  solve_type = 'PJFNK'

  verbose = true
  nl_abs_tol = 1e-10
  start_time = 0.0

  num_steps = 65
  end_time = 2.002e6
  [./TimeStepper]
    type = IterationAdaptiveDT
    # 时间的限制函数
    timestep_limiting_function = Fiss_Function
    max_function_change = 3e7
    dt = 1e6
  [../]
[]

[Postprocessors]
  [./Temperature_of_Block]
    type = ElementAverageValue
    variable = temp
    execute_on = 'initial timestep_end'
  [../]

  [./vonMises]
    type = ElementAverageValue
    variable = vonmises_stress
    execute_on = 'initial timestep_end'
  [../]
[]

[Outputs]
  [./out]
    type = Exodus
    elemental_as_nodal = true
  [../]
  [./console]
    type = Console
    max_rows = 10
  [../]
  [./checkpoint]
    # 会产生一个文件名+checkpoint的文件夹
    type = Checkpoint
    num_files = 1
  [../]
[]

# 总共是65步，跟start_time相关，应该是第一步的时间选取的时间有关系