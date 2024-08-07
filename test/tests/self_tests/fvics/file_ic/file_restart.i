[Mesh]
  [fmg]
    type = FileMeshGenerator
    file = restart_from.e
    use_for_exodus_restart = true
  []
[]

[Variables]
  [u]
    type = MooseVariableFVReal
    initial_from_file_var = u
  []
[]

[Executioner]
  type = Steady
[]

[Problem]
  solve = false
[]

[Outputs]
  exodus = true
[]
