[Mesh]
  file = contact.e
[]

[GlobalParams]
  volumetric_locking_correction = false
  displacements = 'disp_x disp_y disp_z'
[]

[Modules/TensorMechanics/Master]
  [./all]
    add_variables = true
    strain = FINITE
    generate_output = 'stress_xx'
  [../]
[]

[Contact]
  [./dummy_name]    
  # primary和secondary在罚函数以及动力学中，接触压会出现在secondary上，primary上并没有力
    primary = 3
    secondary = 2
    penalty = 5e6
    # penalty 算得接触压比kinematic的接触压大
    formulation = penalty
    # 设置primary_secondary_jacobain=false也会改变接触压，目前看都是增大了接触压
    primary_secondary_jacobian = true
    # 设置normalized_penalty=true会改变接触压的大小，接触压变大，猜测是改变了penalty的大小，改为true会增加稳定性
    normalize_penalty = true
  [../]
[]

[BCs]
  [./left_x]
    type = DirichletBC
    variable = disp_x
    boundary = 1
    value = 0.0
  [../]

  [./left_y]
    type = DirichletBC
    variable = disp_y
    boundary = 1
    value = 0.0
  [../]

  [./left_z]
    type = DirichletBC
    variable = disp_z
    boundary = 1
    value = 0.0
  [../]

  [./right_x]
    type = DirichletBC
    variable = disp_x
    boundary = 4
    value = -0.0001
  [../]

  [./right_y]
    type = DirichletBC
    variable = disp_y
    boundary = 4
    value = 0.0
  [../]

  [./right_z]
    type = DirichletBC
    variable = disp_z
    boundary = 4
    value = 0.0
  [../]
[]

[Materials]
  [./stiffStuff]
    type = ComputeIsotropicElasticityTensor
    block = '1 2'
    youngs_modulus = 1e6
    poissons_ratio = 0.3
  [../]
  [./stiffStuff_stress]
    type = ComputeFiniteStrainElasticStress
    block = '1 2'
  [../]
[]

[Executioner]
  type = Transient
  solve_type = 'PJFNK'

  petsc_options_iname = '-pc_type -pc_hypre_type -ksp_gmres_restart'
  petsc_options_value = 'hypre    boomeramg      101'

  line_search = 'none'

  nl_abs_tol = 1e-8

  l_max_its = 100
  nl_max_its = 10
  dt = 1.0
  num_steps = 1
[]

[Outputs]
  exodus = true
[]
