class AssertionsController < DashboardController
  before_action :set_assertion, only: [:show, :edit, :update, :destroy]
  before_action :set_check

  # GET /assertions/1/edit
  def edit
  end

  # POST /assertions
  # POST /assertions.json
  def create
    @assertion = Assertion.new(assertion_params)
    @assertion.check = @check

    respond_to do |format|
      if @assertion.save
        format.html { redirect_to edit_check_path(@assertion.check), notice: 'Assertion was successfully created.' }
        format.json { render :show, status: :created, location: @assertion }
      else
        format.html { render :new }
        format.json { render json: @assertion.errors, status: :unprocessable_entity }
      end
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
      if !@assertion.check? || !CheckPolicy::can_manage?(@assertion.check, current.user)
        head :forbidden
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def assertion_params
      params.require(:assertion).permit(:subject, :condition, :operand)
    end

    def set_check
      begin
        if @assertion
          @check = @assertion.check
        else
          if check_id = params['assertion'][:check_id]
            @check = Check.find(check_id)
          end
        end
      rescue
        head :bad_request
      end

      if !@check || !CheckPolicy::can_manage?(@check, current.user)
        head :bad_request
      end
    end
end
