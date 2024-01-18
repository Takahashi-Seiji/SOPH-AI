class RemindersController < ApplicationController
  def create
    @reminder = Reminder.new(reminder_params)
    @reminder.user = current_user
    authorize @reminder
    if @reminder.save
      redirect_to dashboard_path
    end
  end

  def reminder_params
    params.require(:reminder).permit(:name, :start_time, :end_time, :date)
  end
end
