class CoursesController < ApplicationController
  # GET /courses
  # GET /courses.json
  def index
    @courses = Course.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @courses }
    end
  end

  # GET /courses/1
  # GET /courses/1.json
  def show
    @course = Course.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @course }
    end
  end

  # GET /courses/new
  # GET /courses/new.json
  def new
    @course = Course.new
    #2.times {@course.lessons.build}
   
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @course }
    end
  end

  # GET /courses/1/edit
  def edit
    @course = Course.find(params[:id])
    #2.times {@course.lessons.build}
  end

  # POST /courses
  # POST /courses.json
  def create
    @course = Course.new(params[:course])
    @course_id = params[:id]
    respond_to do |format|
      if @course.save
        format.html { redirect_to @course, notice: 'Course was successfully created.' }
        format.json { render json: @course, status: :created, location: @course }
      else
        format.html { render action: "new" }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /courses/1
  # PUT /courses/1.json
  def update
    @course = Course.find(params[:id])

    respond_to do |format|
      if @course.update_attributes(params[:course])
        format.html { redirect_to @course, notice: 'Course was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /courses/1
  # DELETE /courses/1.json
  def destroy
    @course = Course.find(params[:id])

#destroy lessons belonging to course
    @course.lessons.each {
      |lesson|
        lesson.assets.destroy
        FileUtils.rm_rf "#{Rails.root}/public/attachments/lessons/#{lesson.id}" #destroy folder belonging to that lesson
        lesson.destroy
    }

    FileUtils.remove_file "#{Rails.root}/public/attachments/courses/#{@course.name}.zip" #remove the courses Zipfile
    @course.destroy #destroy course object
     
    respond_to do |format|
      format.html { redirect_to courses_url }
      format.json { head :no_content }
    end
  end
  
  def downloadcourse
   t = Course.find(params[:theid])
   send_file "#{Rails.root}/public/attachments/courses/#{t.name}.zip", :type=>"application/zip" 
  end

end
