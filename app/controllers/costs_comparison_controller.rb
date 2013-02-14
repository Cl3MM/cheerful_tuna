class CostsComparisonController < ApplicationController
  def index
    debug "#{params}"
    @q = if params[:costs_comparison].present?
               CostsComparison.new(params[:costs_comparison])
             else
               CostsComparison.new
             end
    @q.convert_to_integer if @q.valid?
    debug "#{@q.ceres_contribution_fee}"
    debug "#{@q.ceres_max_contribution}"
    render action: :index
  end
end
