class StudentsController < ApplicationController
  def index
    @students = Student.includes(:family).order(:name)
  end
end
