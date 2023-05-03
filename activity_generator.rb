require 'logger'
require 'json'
require 'socket'

class ActivityGenerator
  attr_reader :logger

  def initialize(log_file_name=nil)
    @logger = Logger.new(log_file_name || STDOUT)
  end

  def start_process(path_to_executable_file, *args)
    io = IO.popen([path_to_executable_file, *args].join(' '))
    
    pid = io.pid
    log_process_start(pid)
    Process.wait(pid)
  end

  def create_file(path_to_file)
    file = File.new(path_to_file, 'w')
    file.close
    log_file_activity('create', path_to_file)
    file
  end

  def modify_file(path_to_file)
    file = File.open(path_to_file, 'a')
    file.write('test')
    file.close
    log_file_activity('modify', path_to_file)
    file
  end

  def delete_file(path_to_file)
    File.delete(path_to_file)
    log_file_activity('delete', path_to_file)
  end

  def establish_network_connection_and_transmit_data
    socket = TCPSocket.new('google.com', 80)
    socket.write("GET / HTTP/1.0\r\n\r\n")
    log_network_connection(socket)
    socket.close
  end

  private

  def get_process_info(pid)
    ps_aux_response_io = IO.popen("ps aux #{pid}")
    ps_aux_responses = ps_aux_response_io.read.split("\n").drop(1)
    processes = ps_aux_responses.map do |line|
      attrs = line.split(/\s+/)
      {
        username: attrs[0],
        id: attrs[1],
        command_line: attrs[10..-1].join(' ')
      }
    end
    processes[0]
  end

  def format_log_line(pid, attrs)
    process = get_process_info(pid)

    log_line = {
      timestamp: Time.now,
      username: process[:username],
      process_name: $PROGRAM_NAME,
      process_command_line: process[:command_line],
      process_id: process[:id]
    }.merge(attrs)

    log_line.to_json
  end

  def log_process_start(pid)
    logger.info format_log_line(pid, {
      event: 'process_start'
    })
  end

  def log_file_activity(activity, path_to_file)
    pid = Process.pid
    logger.info format_log_line(pid, {
      event: 'file_activity',
      activity_descriptor: activity,
      path_to_file: File.expand_path(path_to_file)
    })
  end

  def log_network_connection(socket)
    pid = Process.pid
    logger.info format_log_line(pid, {
      event: 'network_connection',
      destination_address: socket.peeraddr[3],
      destination_port: socket.peeraddr[1],
      source_address: socket.addr[3],
      source_port: socket.addr[1],
      bytes_sent: socket.bytes.count,
      protocol: socket.class
    })
  end
end

activity_generator = ActivityGenerator.new('activity_generator.txt')


activity_generator.start_process('ls', '-l')
activity_generator.create_file('test.txt')
activity_generator.modify_file('test.txt')
activity_generator.delete_file('test.txt')
activity_generator.establish_network_connection_and_transmit_data
