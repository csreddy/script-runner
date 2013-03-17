class ScriptsController < ApplicationController
 helper_method :sort_column, :sort_direction

  # GET /scripts
  # GET /scripts.json
  def index
    @scripts = Script.order(sort_column + " " + sort_direction)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @scripts }
      format.csv { send_data @scripts.to_csv }	
      format.xls { send_data @scripts.to_csv(col_sep: "\t") }
      format.xml  
    end
  end

  # GET /scripts/1
  # GET /scripts/1.json
  def show
	@script = Script.find(params[:id])
	script = Script.find(params[:id])
	cmd = script.command
	prm = script.param
	@pwd = `pwd`
	@host = `uname -mns`
	@cmd = "#{cmd} #{prm}"
	error_log = "error_#{script.id}.txt"
	success_log = "success_#{script.id}.txt"
	log_dir = "#{Rails.root}/script-logs/"
	
	File.exist?(log_dir + error_log) ? @error = File.read(log_dir + error_log) : @error = 'no stderror'
	File.exist?(log_dir + success_log) ? @success = File.read(log_dir + success_log) : @success = 'no stdout'

	File.exist?(log_dir + success_log) ? @timestamp = File.ctime(log_dir + success_log) : @timestamp = Time.parse("01-01-2012")

        @timestamp_msg = "This script was last executed at " + ( @timestamp.strftime("%a %b %e %r %Y") if (@timestamp.year > 2012)).to_s 
        @timestamp_msg if (@timestamp.year > 2012)
	#@error = File.read(log_dir + error_log) unless File.exist?(log_dir + error_log)
	#@success = File.read(log_dir + success_log) unless File.exist?(log_dir + error_log)
	respond_to do |format|
	 format.html
	 format.json { render json: @script }
	 format.js  
	end


  end

  # GET /scripts/new
  # GET /scripts/new.json
  def new
    @script = Script.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @script }
    end
  end

  # GET /scripts/1/edit
  def edit
    @script = Script.find(params[:id])
script_name = "script_#{@script.id}.sh"
`dos2unix script/#{script_name}`
  end

  # POST /scripts
  # POST /scripts.json
  def create
    @script = Script.new(params[:script])

    respond_to do |format|
      if @script.save
	script_name = "script_#{@script.id}.sh"
	File.open("script/#{script_name}", 'w+') {} 
	`chmod 775 script/#{script_name}`
        format.html { redirect_to @script, notice: 'Script was successfully created.' }
        format.json { render json: @script, status: :created, location: @script }
	format.js
      else
        format.html { render action: "new" }
        format.json { render json: @script.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /scripts/1
  # PUT /scripts/1.json
  def update
    @script = Script.find(params[:id])

    respond_to do |format|
      if @script.update_attributes(params[:script])
        format.html { redirect_to @script, notice: 'Script was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @script.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /scripts/1
  # DELETE /scripts/1.json
  def destroy
    @script = Script.find(params[:id])
    @script.destroy
# delete script file
     script_name = "script_#{@script.id}.sh"
     File.delete("script/#{script_name}")

# Delete error/success logs
error_log = "error_#{@script.id}.txt"
success_log = "success_#{@script.id}.txt"
log_dir = "#{Rails.root}/script-logs/"
 File.delete(log_dir + error_log) unless !File.exist?(log_dir + error_log)
 File.delete(log_dir + success_log) unless !File.exist?(log_dir + success_log)
    respond_to do |format|
      format.html { redirect_to scripts_url }
      format.json { head :no_content }
    end
  end

def run
@script = Script.find(params[:id])
script = Script.find(params[:id])
cmd = script.command
prm = script.param
@pwd = `pwd`
@host = `uname -mns`
@cmd = "#{cmd} #{prm}"
error_log = "error_#{script.id}.txt"
success_log = "success_#{script.id}.txt"
log_dir = "#{Rails.root}/script-logs/"
script_name = "script_#{script.id}.sh"
#delete previous success/error logs
 File.delete(log_dir + error_log) unless !File.exist?(log_dir + error_log)
 File.delete(log_dir + success_log) unless !File.exist?(log_dir + success_log)

 File.open("script/#{script_name}", 'w') {|f| f.write("#{cmd}") }
`dos2unix script/#{script_name}`
 `sh #{Rails.root}/script/#{script_name} 2> #{log_dir}#{error_log} 1> #{log_dir}#{success_log}`
# `#{cmd} #{prm} 2> #{log_dir}#{error_log} 1> #{log_dir}#{success_log}`
@run_cmd =  "#{cmd} #{prm} 2> #{log_dir}#{error_log} 1> #{log_dir}#{success_log}"
File.exist?(log_dir + error_log) ? @error = File.read(log_dir + error_log) : @error = 'no stderror'
File.exist?(log_dir + success_log) ? @success = File.read(log_dir + success_log) : @success = 'no stdout'
respond_to do |format|
 format.html
 format.js  
end
end

def log
script = Script.find(params[:id])
@script = Script.find(params[:id])
log_dir = "#{Rails.root}/script-logs/"
error_log = "error_#{script.id}.txt"
success_log = "success_#{script.id}.txt"
File.exist?(log_dir + error_log) ? @error = File.read(log_dir + error_log) : @error = 'no stderror'
File.exist?(log_dir + success_log) ? @success = File.read(log_dir + success_log) : @success = 'no stdout'
end



private
  
    def sort_column
      Script.column_names.include?(params[:sort]) ? params[:sort] : "name"
    end
  
    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
    end

end
