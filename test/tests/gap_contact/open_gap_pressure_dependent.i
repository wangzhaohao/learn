## Units in the input file: m-Pa-s-K

[GlobalParams]
  displacements = 'disp_x disp_y'
[]

[Mesh]
  [left_rectangle]
    type = GeneratedMeshGenerator
    dim = 2
    nx = 40
    ny = 10
    xmax = 1
    ymin = 0
    ymax = 0.5
    boundary_name_prefix = moving_block
  []
  [left_block]
    type = SubdomainIDGenerator
    input = left_rectangle
    subdomain_id = 1
  []
  [right_rectangle]
    type = GeneratedMeshGenerator
    dim = 2
    nx = 40
    ny = 10
    xmin = 1.0000001
    xmax = 2.0000001
    ymin = 0
    ymax = 0.5
    boundary_name_prefix = fixed_block
    boundary_id_offset = 4
  []
  [right_block]
    type = SubdomainIDGenerator
    input = right_rectangle
    subdomain_id = 2
  []
  [two_blocks]
    type = MeshCollectionGenerator
    inputs = 'left_block right_block'
  []
  [block_rename]
    type = RenameBlockGenerator
    input = two_blocks
    old_block = '1 2'
    new_block = 'left_block right_block'
  []
  patch_update_strategy = iteration
[]

[Variables]
  [disp_x]
    block = 'left_block right_block'
  []
  [disp_y]
    block = 'left_block right_block'
  []
  [temperature]
    initial_condition = 525.0
  []
  [temperature_interface_lm]
    block = 'interface_secondary_subdomain'
  []
[]

[Modules]
  [TensorMechanics/Master]
    [steel]
      strain = FINITE
      add_variables = false
      use_automatic_differentiation = true
      generate_output = 'strain_xx strain_xy strain_yy stress_xx stress_xy stress_yy'
      additional_generate_output = 'vonmises_stress'
      additional_material_output_family = 'MONOMIAL'
      additional_material_output_order = 'FIRST'
      block = 'left_block'
    []
    [aluminum]
      strain = FINITE
      add_variables = false
      use_automatic_differentiation = true
      generate_output = 'strain_xx strain_xy strain_yy stress_xx stress_xy stress_yy'
      additional_generate_output = 'vonmises_stress'
      additional_material_output_family = 'MONOMIAL'
      additional_material_output_order = 'FIRST'
      block = 'right_block'
    []
  []
[]

[Kernels]
  [HeatDiff_steel]
    type = ADHeatConduction
    variable = temperature
    thermal_conductivity = steel_thermal_conductivity
    block = 'left_block'
  []
  [HeatDiff_aluminum]
    type = ADHeatConduction
    variable = temperature
    thermal_conductivity = aluminum_thermal_conductivity
    block = 'right_block'
  []
  [timeDerivative_steel]
    type = ADHeatConductionTimeDerivative
    variable = temperature
    block = 'left_block'
    density_name = steel_density
    specific_heat = steel_heat_capacity 
  []
  [timeDerivative_aluminum]
    type = ADHeatConductionTimeDerivative
    variable = temperature
    block = 'right_block'
    density_name = aluminum_density
    specific_heat = aluminum_heat_capacity 
  []
[]
[ThermalContact]
  [thermal_contact]
    type = GapHeatTransfer
    variable = temperature
    primary = 'moving_block_right'
    secondary = 'fixed_block_left'
    emissivity_primary = 0
    emissivity_secondary = 0
    gap_conductivity = 0.484512
    quadrature = true
    gap_geometry_type = PLATE
  []
[]

[BCs]
  [fixed_bottom_edge]
    type = ADDirichletBC
    variable = disp_y
    value = 0
    boundary = 'moving_block_bottom fixed_block_bottom'
  []
  [fixed_bottom]
    type = ADDirichletBC
    variable = disp_x
    value = 0
    boundary = 'moving_block_bottom fixed_block_bottom'
  []
  [fixed_outer_edge]
    type = ADDirichletBC
    variable = disp_x
    value = 0
    boundary = 'fixed_block_right'
  []
  [pressure_left_block]
    type = Pressure
    variable = disp_y
    boundary = 'moving_block_top'
    function = 1e6*t
  []
  [temperature_left]
    type = ADDirichletBC
    variable = temperature
    value = 800
    boundary = 'moving_block_left'
  []
  [temperature_right]
    type = ADDirichletBC
    variable = temperature
    value = 250
    boundary = 'fixed_block_right'
  []
[]

[Contact]
  [interface]
    primary = moving_block_right
    secondary = fixed_block_left
    model = frictionless
    formulation = mortar
    correct_edge_dropping = true
  []
[]

[Constraints]
  [thermal_contact]
    type = ModularGapConductanceConstraint
    variable = temperature_interface_lm
    secondary_variable = temperature
    primary_boundary = moving_block_right
    primary_subdomain = interface_primary_subdomain
    secondary_boundary = fixed_block_left
    secondary_subdomain = interface_secondary_subdomain
    gap_flux_models = 'closed'
    use_displaced_mesh = true
  []
[]

[Materials]
  [steel_elasticity_tensor]
    type = ADComputeIsotropicElasticityTensor
    youngs_modulus = 1.93e11 #in Pa, 193 GPa, stainless steel 304
    poissons_ratio = 0.29
    block = 'left_block'
  []
  [steel_stress]
    type = ADComputeLinearElasticStress
    block = 'left_block'
  []
  [steel_density]
    type = ADGenericConstantMaterial
    prop_names = 'steel_density'
    prop_values = 8e3 #in kg/m^3, stainless steel 304
    block = 'left_block'
  []
  [steel_thermal_properties]
    type = ADGenericConstantMaterial
    prop_names = 'steel_thermal_conductivity steel_heat_capacity steel_emissivity'
    prop_values = '16.2 0.5 0.6' ## for stainless steel 304
    block = 'left_block'
  []

  [aluminum_elasticity_tensor]
    type = ADComputeIsotropicElasticityTensor
    youngs_modulus = 6.8e10 #in Pa, 68 GPa, aluminum
    poissons_ratio = 0.36
    block = 'right_block'
  []
  [aluminum_stress]
    type = ADComputeLinearElasticStress
    block = 'right_block'
  []
  [aluminum_density]
    type = ADGenericConstantMaterial
    prop_names = 'aluminum_density'
    prop_values = 2.7e3 #in kg/m^3, stainless steel 304
    block = 'right_block'
  []
  [aluminum_thermal_properties]
    type = ADGenericConstantMaterial
    prop_names = 'aluminum_thermal_conductivity aluminum_heat_capacity aluminum_emissivity'
    prop_values = '210 0.9 0.25'
    block = 'right_block'
  []
[]

[UserObjects]
  [closed]
    type = GapFluxModelPressureDependentConduction
    primary_conductivity = steel_thermal_conductivity
    secondary_conductivity = aluminum_thermal_conductivity
    temperature = temperature
    primary_hardness = 1000.0
    secondary_hardness = 1.0
    boundary = 'moving_block_right'
    contact_pressure = interface_normal_lm
  []
[]

[Postprocessors]
  [steel_pt_interface_temperature]
    type = NodalVariableValue
    nodeid = 245
    variable = temperature
  []
  [aluminum_pt_interface_temperature]
    type = NodalVariableValue
    nodeid = 657
    variable = temperature
  []
  [interface_heat_flux_steel]
    type = ADSideDiffusiveFluxAverage
    variable = temperature
    boundary = moving_block_right
    diffusivity = steel_thermal_conductivity
  []
  [interface_heat_flux_aluminum]
    type = ADSideDiffusiveFluxAverage
    variable = temperature
    boundary = fixed_block_left
    diffusivity = aluminum_thermal_conductivity
  []
  [steel_element_interface_stress]
    type = ElementalVariableValue
    variable = vonmises_stress
    elementid = 199
  []
  [aluminum_element_interface_stress]
    type = ElementalVariableValue
    variable = vonmises_stress
    elementid = 560
  []
[]


[Executioner]
  type = Transient
  end_time = 1.0
  dt = 0.1
  solve_type = NEWTON
  automatic_scaling = false
  
#  petsc_options_iname = '-pc_type -pc_fator_mat_solver_package'
#  petsc_options_value = 'lu        superlu_dist'

  line_search = 'none'
  nl_abs_tol = 1e-5
  nl_rel_tol = 1e-5
  l_tol = 1e-5
  l_max_its = 30
  nl_max_its = 30
[]

[Outputs]
  exodus = true
[]
