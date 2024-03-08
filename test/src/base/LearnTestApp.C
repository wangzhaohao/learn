//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html
#include "LearnTestApp.h"
#include "LearnApp.h"
#include "Moose.h"
#include "AppFactory.h"
#include "MooseSyntax.h"

InputParameters
LearnTestApp::validParams()
{
  InputParameters params = LearnApp::validParams();
  params.set<bool>("use_legacy_material_output") = false;
  return params;
}

LearnTestApp::LearnTestApp(InputParameters parameters) : MooseApp(parameters)
{
  LearnTestApp::registerAll(
      _factory, _action_factory, _syntax, getParam<bool>("allow_test_objects"));
}

LearnTestApp::~LearnTestApp() {}

void
LearnTestApp::registerAll(Factory & f, ActionFactory & af, Syntax & s, bool use_test_objs)
{
  LearnApp::registerAll(f, af, s);
  if (use_test_objs)
  {
    Registry::registerObjectsTo(f, {"LearnTestApp"});
    Registry::registerActionsTo(af, {"LearnTestApp"});
  }
}

void
LearnTestApp::registerApps()
{
  registerApp(LearnApp);
  registerApp(LearnTestApp);
}

/***************************************************************************************************
 *********************** Dynamic Library Entry Points - DO NOT MODIFY ******************************
 **************************************************************************************************/
// External entry point for dynamic application loading
extern "C" void
LearnTestApp__registerAll(Factory & f, ActionFactory & af, Syntax & s)
{
  LearnTestApp::registerAll(f, af, s);
}
extern "C" void
LearnTestApp__registerApps()
{
  LearnTestApp::registerApps();
}
