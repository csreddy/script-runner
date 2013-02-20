module ScriptsHelper
def log_exists?(script)
    #script = Script.find(params[:id])
    success_log = "success_#{script.id}.txt"
    log_dir = "#{Rails.root}/script-logs/"
    File.exists?(log_dir + success_log)
end

def ssh_exec
 Net::SSH.start("cluster-003", "builder", :password => "Bu@ml%24") do |ssh|
	script = Script.find(params[:id])	
	cmd = script.command
	prm = script.param	
	ssh_error_log = "error_ssh_#{script.id}.txt"
	ssh_success_log = "success_ssh_#{script.id}.txt"
	error_log = "error_#{script.id}.txt"
	success_log = "success_#{script.id}.txt"
	log_dir = "#{Rails.root}/script-logs/"
	  
result = ssh.exec!("#{cmd}#{prm} 2> /tmp/error_ssh.log 1> /tmp/success_ssh.log | scp /tmp/error_ssh.log /tmp/success_ssh.log sreddy:/tmp}")
 end
'cat /tmp/#{ssh_error_log} >> #{log_dir}#{error_log}'
'cat /tmp/#{ssh_success_log} >> #{log_dir}#{success_log}'


#File.exist?(log_dir + error_log) ? @error = File.read(log_dir + error_log) : @error = 'no stderror found'
#File.exist?(log_dir + success_log) ? @success = File.read(log_dir + success_log) : @success = 'no stdout found'

end
end
