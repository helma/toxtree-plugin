class Toxtree

  require 'rjb'
  attr_reader :cramer_class, :css_class, :explanation

  def initialize(smiles)

    builder = Rjb::import('org.openscience.cdk.DefaultChemObjectBuilder').getInstance()
    sp = Rjb::import('org.openscience.cdk.smiles.SmilesParser').new(builder)
    mol = sp.parseSmiles(smiles)

    result = Rjb::import('toxTree.tree.cramer.CramerRules').new.createDecisionResult()
    result.classify(mol) 

    @cramer_class = result.getCategory().getName()
    case @cramer_class
    when /High/
      @css_class = 'active'
    when /Intermediate/
      @css_class = 'unknown'
    when /Low/
      @css_class = 'inactive'
    end
    @explanation = result.getCategory().getExplanation()
    nrResults = result.getRuleResultsCount()
    nrResults -= 1
    @rules = []
    (0..nrResults).each do |i|
      @rules << result.getRuleResult(i).toString()
    end

  end

end

