# Engineering Interview Homework Assignment

## My Solution

I created a Ruby class called `ActivityGenerator` that can generate the desired endpoint activity. I took the code that calls those methods, and put them into a class called EdmTester, so that you could call `EdrTester.run_tests` and run through all the different activities. Then I added a file called `main.rb` that you can run from the command line with `rb main.rb` to invoke the program. 

### How did it go?

I had to learn some new Ruby methods in order to solve this problem. As a web developer, I don't often write code that interacts with the actual computer it's running on - almost all the code I've written runs on a web server or in a browser in order to handle web requests and web application data. I only rarely see code that talks to the Unix kernel. I did some research and brushed up on the available methods in Ruby's Process module, and then came back to the task. I'm glad I took the time to do this assignment, because it got me excited about the work that Red Canary is doing and the kinds of problems that I might get to solve there. 

### What would I do next?

I'd love to actually test this code with an EDR agent and to see it working. 


I only tested it on my apple laptop, but I don't see any reason that it wouldn't work just as well on a linux machine, and I believe that it would also run on a Windows machine, if I had one handy. The reason I believe that it would work on a Windows machine is because some of the methods in the Ruby documentation tell about how those methods work differently in different OSes, but the methods I used don't seem to, so I believe that this will work on any operating system that can run Ruby. 

I thought about refactoring this code into more files, with an object-oriented approach where each type of activity has its own class that implements its own `run` and `log` methods, but it felt like overengineering, and I didn't think it was worth it to go down that route. If we had plans to add many more types of events, it might make sense to DRY this up further to make it easier to add different types of events. 



### How to operate the program

You can run `rb main.rb` on the command line and then `less activity_generator.log` to see the logs that were generated.

When you run `main.rb`, it invokes `EdrTester.run_tests` which generates a pre-defined list of endpoint activity. 

`EdrTester.run_tests` generates these activities:
- it starts a process (by default, it runs everyone's favorite process, `ls`), 
- it creates a file, modifies that file, and then deletes that file, 
- it opens a TCP socket, transmits a little bit of data on that socket, and then closes the socket, 
- and it logs each step of the process into a log file. 

By default, the logs are recorded in a file called activity_generator.log, but you can also log to STDOUT by creating an instance of ActivityGenerator without a log file name:
`activity_generator = ActivityGenerator.new`

If you want to start a different process, you can run the individual public methods available on ActivityGenerator, which are:

```
activity_generator = ActivityGenerator.new(log_file_name)
activity_generator.start_process(process_name, args)
activity_generator.create_file(file_name)
activity_generator.modify_file(file_name)
activity_generator.delete_file(file_name)
activity_generator.establish_network_connection_and_transmit_data
```


## Appendix A: The assignment

Red Canary processes telemetry from Endpoint Detection and Response (EDR) agents.

This telemetry includes activity such as:
- Process creation
- File creation
- File creation, modification, and deletion
- Registry key creation, modification, and deletion (Windows)
- Registry value creation, modification, and deletion (Windows)

One concern when the EDR agent is updated is if there are regressions in the data it
emits. Red Canary needs a way to ensure that our core telemetry is still properly
emitted when EDR agents are updated.
Assignment Instructions
Your assignment, should you choose to accept it, is to create a framework that allows
us to generate endpoint activity across at least two of three supported platforms
(Windows, macOS, Linux). This program will allow us to test an EDR agent and ensure
it generates the appropriate telemetry.

Your program should trigger the following activity:
- Start a process, given a path to an executable file and the desired (optional)
command-line arguments
- Create a file of a specified type at a specified location
- Modify a file
- Delete a file
- Establish a network connection and transmit data

Additionally, your program should keep a log of the activity it triggered. The activity log
allows us to correlate what data the test program generated with the actual data
recorded by an EDR agent.

This log should be in a machine friendly format (e.g. CSV, TSV, JSON, YAML, etc).
Each data type should contain the following information:
- Process start
    * Timestamp of start time
    * Username that started the process
    * Process name
    * Process command line
    * Process ID
- File creation, modification, deletion
    * Timestamp of activity
    * Full path to the file
    * Activity descriptor - e.g. create, modified, delete
    * Username that started the process that created/modified/deleted the file
    * Process name that created/modified/deleted the file
    * Process command line
    * Process ID
- Network connection and data transmission
    * Timestamp of activity
    * Username that started the process that initiated the network activity
    * Destination address and port
    * Source address and port
    * Amount of data sent
    * Protocol of data sent
    * Process name
    * Process command line
    * Process ID

You may use any programming language you choose, so long as it supports all three
platforms (Windows, macOS, Linux). We understand that not everyone may have
access to all platforms and can assist in setting up a test environment for you.
The code should be placed on GitHub or a similar platform so that we can review your
changes.
Finally, once you’ve completed the project, please write a short one page document
describing what you’ve created and how it works.

### Final Deliverables
The following is the list of final deliverables:
- The coding project as outlined above in the “Assignment” section.
- Brief one page document describing the project and how it works.

You’re free to ask questions and brainstorm with Red Canary engineers. You do
not have to solve this in a vacuum but you will have to write all code yourself.
