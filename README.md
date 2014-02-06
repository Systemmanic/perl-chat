PerlChat
========

The PerlChat script allows communication, between two computers, over a network similar to an instant messaging application. It allows both participants to send messages simultaneously; displaying both sent messages and received messages in real time, inside the terminal window.


Workings
========

PerlChat handles text input from the user whilst displaying any incoming messages on screen. It follows a simple protocol based on who starts the application first. When run, the user is asked for a network address and port to connect to. If the connection is denied the application creates a new instance on their own machine listing on the specified port. This helps prevent a miscommunication between the two participants e.g. both instances waiting for an incoming connection to begin the chat. 

When a user connects to the waiting instance, PerlChat announces the connection and begins listening for incoming messages to print whilst waiting for user input. This is achieved through the use of forking. If the program fails to run correctly an error is displayed otherwise the process is forked. This procedure is applied to PerlChat to allow simultaneous communication where the parent listens and the child waits for input via the keyboard. The messages are sent through sockets that can read and write like file handles.

As these are handled the same in Perl it allows complex programs to communicate simply. You can include socket handling in your Perl scripts by including the socket interface and defining the connection parameters.

To connect to an open socket in Perl you only supply the address and port. This is what is used to test if a server is listening in PerlChat, if successful the chat begins. It’s also important on termination not to leave “zombie” processes behind. In PerlChat these are closed using the kill command. However, if the application closes unexpectedly and the kill command does not execute you will leave the child process running with no parent. PerlChat overcomes this problem with the use of the ignore child function.

User input and socket output, is controlled by Perl’s standard in, standard out functions. Standard input waits for user input in the shell where it’s running, whilst standard output prints to the terminal screen. To print down socket, the print command is used in conjunction with our declared socket variable.

This command will print whatever variable is defined to $out through the socket. The parent process listing on the receiving machine will then print the message from the socket to the screen. If the incoming message is equal to /quit it will close the socket and kill the process. This lets the other user know that you have left chat. If the input is equal to /ping the program calls upon a sub routine called &ping and creates a sound.


Features
========

The sent messages are displayed in the users own terminal colour, whilst the incoming messages are displayed in a bold coloured font. This helps differentiate between messages.

During startup the user is asked for some basic information including a username, which is displayed on the receivers screen beside any incoming messages and is stored in the $name variable. 

Similarly, the network address and ports are requested and stored in the relevant variables. When information is printed on screen that is to be a different colour, the required subroutine is called that sets the colour, prints the text supplied then resets the colour back to default, to not disturb the user’s terminal when the application exits.

When the /ping command is received the ping subroutine is called that prints ping, capitalised, and rings the terminal bell.

To clear the screen PerlChat makes use of the system (); function. This allows command to be passed to the terminal directly. This is used in the clear subroutine to clear the screen.
