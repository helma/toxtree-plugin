class ToxtreeController < ApplicationController

  def cramer
    #if params[:calculate] == "false" && session["cramer"]
      #@cramer = session["cramer"]
    #else
      @cramer = Toxtree.new(params[:smiles])
    #end
  end

end
