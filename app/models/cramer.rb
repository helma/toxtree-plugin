class Cramer

  require 'rjb'
  attr_reader :cramer_class, :css_class, :explanation

  def initialize(smiles)

    @smiles = smiles

    builder = Rjb::import('org.openscience.cdk.DefaultChemObjectBuilder').getInstance
    sp = Rjb::import('org.openscience.cdk.smiles.SmilesParser').new(builder)
    mol = sp.parseSmiles(smiles)

    result = Rjb::import('toxTree.tree.cramer.CramerRules').new.createDecisionResult
    result.classify(mol) 

    @cramer_class = result.getCategory.getName
    case @cramer_class
    when /High/
      @css_class = 'active'
    when /Intermediate/
      @css_class = 'unknown'
    when /Low/
      @css_class = 'inactive'
    end
    @explanation = result.getCategory.getExplanation
    nrResults = result.getRuleResultsCount
    nrResults -= 1
    @results = []
    (0..nrResults).each do |i|
      @results << result.getRuleResult(i)
    end

  end

  def to_xml
    xml = Builder::XmlMarkup.new
    xml.chronic_toxicity do
      xml.smiles @smiles
      xml.cramer_class @cramer_class
      xml.explanation @explanation
      xml.rules do
        @results.each do |r|
          rule = r.getRule
          xml.rule do
            xml.id rule.getID
            xml.description rule.getTitle
            xml.explanation rule.getExplanation
            xml.result r.isResult
          end
        end
      end
    end
  end

  def to_yaml

    out = { :smiles => @smiles,
      :cramer_class => @cramer_class,
      :explanation => @explanation,
      :rules => []
    }

    @results.each do |r|
      rule = r.getRule
      out[:rules] << {

        :id => rule.getID,
        :description => rule.getTitle,
        :explanation => rule.getExplanation,
        :result => r.isResult

      }
    end

    out.to_yaml

  end

end

