require './activity_generator'

class EdrTester
  def self.run_tests
    file_name = 'test.txt'
    log_file = 'activity_generator.log'
    activity_generator = ActivityGenerator.new(log_file)
    activity_generator.start_process('ls', '-l')
    activity_generator.create_file(file_name)
    activity_generator.modify_file(file_name)
    activity_generator.delete_file(file_name)
    activity_generator.establish_network_connection_and_transmit_data
  end
end
