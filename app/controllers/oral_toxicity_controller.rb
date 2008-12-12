class OralToxicityController < ApplicationController

  def show
    @cramer = Cramer.new(params[:smiles])
    respond_to do |wants|
      wants.html
      wants.xml { render :xml => @cramer.to_xml }
      wants.yaml { render :yaml => @cramer }
   end   
  end

end
