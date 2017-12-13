Add-Type -Path 'Octopus.Client.dll' 

$apikey = 'API-ABC'
$octopusURI = 'http://octopus.com'

$endpoint = New-Object Octopus.Client.OctopusServerEndpoint $octopusURI,$apikey 
$repository = New-Object Octopus.Client.OctopusRepository $endpoint


$libraryVariableSet = New-Object Octopus.Client.Model.LibraryVariableSetResource
$libraryVariableSet.Name = "Ignore config transform errors"
$libraryVariableSet = $repository.LibraryVariableSets.Create($libraryVariableSet)

$ignoreConfigTransformVariable = new-object Octopus.Client.Model.VariableResource
$ignoreConfigTransformVariable.Name = "Octopus.Action.Package.IgnoreConfigTransformationErrors"
$ignoreConfigTransformVariable.Value = "true"

$variables = $repository.VariableSets.Get($libraryVariableSet.VariableSetId)
$variables.Variables.Add($ignoreConfigTransformVariable)
$repository.VariableSets.Modify($variables)

$projects = $repository.Projects.FindAll()
foreach ($project in $projects) {
    $project.IncludedLibraryVariableSetIds.Add($libraryVariableSet.Id)
    $repository.Projects.Modify($project)
}
