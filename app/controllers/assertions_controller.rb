# frozen_string_literal: true

class AssertionsController < DashboardController
  before_action :set_assertion, only: %i[show edit update destroy]
  before_action :set_check

  # GET /assertions/1/edit
  def edit; end

  # POST /assertions
  # POST /assertions.json
  def create
    @assertion = Assertion.new(assertion_params)
    @assertion.check = @check

    if @assertion.save
      format.html { redirect_to edit_check_path(@assertion.check), notice: 'Assertion was successfully created.' }
    else
      format.html { render :new }
    end
  end

  # PATCH/PUT /assertions/1
  # PATCH/PUT /assertions/1.json
  def update
    respond_to do |format|
      if @assertion.update(assertion_params)
        format.html { redirect_to edit_check_path(@assertion.check), notice: 'Assertion was successfully updated.' }
        format.json { render :show, status: :ok, location: @assertion }
      else
        format.html { render :edit }
        format.json { render json: @assertion.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /assertions/1
  # DELETE /assertions/1.json
  def destroy
    @assertion.destroy
    respond_to do |format|
      format.html { redirect_to edit_check_path(@assertion.check), notice: 'Assertion was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_assertion
    @assertion = Assertion.find(params[:id])
    head :forbidden if !@assertion.check? || !CheckPolicy.can_manage?(@assertion.check, current.user)
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def assertion_params
    params.require(:assertion).permit(:subject, :condition, :operand)
  end

  def set_check
    begin
      @check = @assertion&.check
      @check ||= Check.find(params['assertion'][:check_id])
    rescue StandardError
      head :bad_request
    end

    head :bad_request if !@check || !CheckPolicy.can_manage?(@check, current.user)
  end
end
