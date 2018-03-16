# see the URL below for information on how to write OpenStudio measures
# http://nrel.github.io/OpenStudio-user-documentation/reference/measure_writing_guide/

# start the measure
class RemoveOutputDefaultWarning < OpenStudio::Measure::EnergyPlusMeasure

  # human readable name
  def name
    return "Remove Output Default Warning"
  end

  # human readable description
  def description
    return "Remove Output Defaults in BIM2BEM"
  end

  # human readable description of modeling approach
  def modeler_description
    return "This measure is made to remove default outputs included in every OpenStudio simulation. Use this to make sure users aren't confused by extra warnings in the .err report."
  end

  # define the arguments that the user will input
  def arguments(workspace)
    args = OpenStudio::Ruleset::OSArgumentVector.new

    #only one choice
    choices = OpenStudio::StringVector.new
    choices << "RemoveAll"
    removeOutput = OpenStudio::Ruleset::OSArgument::makeChoiceArgument("removeOutput", choices, true)
    removeOutput.setDisplayName("Remove Output Defaults.")
    removeOutput.setDefaultValue("RemoveAll")
    args << removeOutput #add to args vector

    return args
  end

  # define what happens when the measure is run
  def run(workspace, runner, user_arguments)
    super(workspace, runner, user_arguments)

    # use the built-in error checking
    if !runner.validateUserArguments(arguments(workspace), user_arguments)
      return false
    end

    #remove objects added with forward translation
    cls_names = ['LifeCycleCost:Parameters',
             'LifeCycleCost:UsePriceEscalation',
             'LifeCycleCost:NonRecurringCost']

    cls_names.each do |cls_name|
      workspace.getObjectsByType(cls_name.to_IddObjectType).each { |obj| obj.remove }
    end

    return true # proper exist status reporting

  end

end

# register the measure to be used by the application
RemoveOutputDefaultWarning.new.registerWithApplication
