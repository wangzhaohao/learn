[Mesh]
  # 使用GeneratedMesh生成一个简单的网格
  [block1]
    type = GeneratedMeshGenerator
    dim = 2
    nx = 4
    ny = 4
  []
  
  # 使用BreakMeshByElementGenerator分割网格
  [mesh_generators]
    type = BreakMeshByElementGenerator
    input = block1 
    interface_name = czm
    subdomains = 0
  []
[]

[Variables]
  [./u]
    family = LAGRANGE
    order = FIRST
  [../]
[]

[AuxVariables]
  [./v]
    family = LAGRANGE
    order = FIRST
  [../]
[]

[Kernels]
  [./diff]
    type = Diffusion
    variable = u
  [../]
[]

[BCs]
  [./left]
    type = DirichletBC
    variable = u
    boundary = left
    value = 0
  [../]
  [./right]
    type = DirichletBC
    variable = u
    boundary = right
    value = 1
  [../]
  [./new_boundary]
    type = DirichletBC
    variable = u
    boundary = czm
    value = 0.5
  [../]
[]

[Executioner]
  type = Steady
[]

[Outputs]
  exodus = true
[]