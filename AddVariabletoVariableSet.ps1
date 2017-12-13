Add-Type -Path 'Octopus.Client.dll' 

$apikey = 'API-ABC'
$octopusURI = 'http://octopus.com'

$VariableSetName = "variablesetname" 
$variableName = "Variable name" 
$variableValue = "Variable value"

$endpoint = new-object Octopus.Client.OctopusServerEndpoint $octopusURI,$apikey 
$repository = new-object Octopus.Client.OctopusRepository $endpoint

$libraryVariableSet = $repository.LibraryVariableSets.Get($libraryVariableSetId);
$variables = $repository.VariableSets.Get($libraryVariableSet.VariableSetId);

$myNewVariable = new-object Octopus.Client.Model.VariableResource
$myNewVariable.Name = $variableName
$myNewVariable.Value = $variableValue

$variables.Variables.Add($myNewVariable)
$repository.VariableSets.Modify($variables)
