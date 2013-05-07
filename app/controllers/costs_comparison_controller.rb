class CostsComparisonController < ApplicationController
  def index
    @q = if params[:costs_comparison].present?
           CostsComparison.new(params[:costs_comparison])
         else
           CostsComparison.new
         end
    @q.convert_to_integer if @q.valid?
    render action: :index
  end
end
