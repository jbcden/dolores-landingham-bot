class EmployeesController < ApplicationController
  def new
    @employee = Employee.new
    @employee.time_zone = "Eastern Time (US & Canada)"
  end

  def create
    @employee = Employee.new(employee_params)

    if @employee.save
      flash[:notice] = "Thanks for adding #{@employee.slack_username}"
      redirect_to root_path
    else
      flash.now[:error] = @employee.errors.full_messages.to_sentence
      render action: :new
    end
  end

  def index
    if params[:slack_username].present? || params[:started_on].present?
      @employees = Employee.filter(params).order(slack_username: :asc).page(params[:page])
    else
      @employees = Employee.order(created_at: :desc).page(params[:page])
    end
  end

  def edit
    @employee = Employee.find(params[:id])
  end

  def update
    @employee = Employee.find(params[:id])

    if unknown_employee(params[:employee][:slack_username])
      flash.now[:error] = "There is not a slack user with the username \"#{params[:employee][:slack_username]}\" in your organization."
      render action: :edit
    elsif @employee.update(employee_params)
      flash[:notice] = "Employee updated successfully"
      redirect_to employees_path
    else
      flash.now[:error] = "Could not update employee"
      render action: :edit
    end
  end

  def destroy
    @employee = Employee.find(params[:id])
    @employee.destroy

    flash[:notice] = "You deleted #{@employee.slack_username}"
    redirect_to employees_path
  end

  private

  def employee_params
    params.require(:employee).permit(:slack_username, :started_on, :time_zone)
  end

  def unknown_employee(slack_username)
    !EmployeeFinder.new(slack_username).existing_employee?
  end
end
