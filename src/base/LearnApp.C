#include "LearnApp.h"
#include "Moose.h"
#include "AppFactory.h"
#include "ModulesApp.h"
#include "MooseSyntax.h"

InputParameters
LearnApp::validParams()
{
  InputParameters params = MooseApp::validParams();
  params.set<bool>("use_legacy_material_output") = false;
  return params;
}

LearnApp::LearnApp(InputParameters parameters) : MooseApp(parameters)
{
  LearnApp::registerAll(_factory, _action_factory, _syntax);
}

LearnApp::~LearnApp() {}

void 
LearnApp::registerAll(Factory & f, ActionFactory & af, Syntax & s)
{
  ModulesApp::registerAllObjects<LearnApp>(f, af, s);
  Registry::registerObjectsTo(f, {"LearnApp"});
  Registry::registerActionsTo(af, {"LearnApp"});

  /* register custom execute flags, action syntax, etc. here */
}

void
LearnApp::registerApps()
{
  registerApp(LearnApp);
}

/***************************************************************************************************
 *********************** Dynamic Library Entry Points - DO NOT MODIFY ******************************
 **************************************************************************************************/
extern "C" void
LearnApp__registerAll(Factory & f, ActionFactory & af, Syntax & s)
{
  LearnApp::registerAll(f, af, s);
}
extern "C" void
LearnApp__registerApps()
{
  LearnApp::registerApps();
}
