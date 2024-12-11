function closeDatagramSocket
    port = 8888;
    % Import necessary Java classes
    import java.lang.management.ManagementFactory
    import java.lang.Class
    import java.lang.reflect.Field
    
    % Get reference to the JVM's memory management beans
    beans = ManagementFactory.getMemoryMXBean();
    
    % Force garbage collection to clear out dead references (optional)
    beans.gc();
    
    % Get all active instances of DatagramSocket
    sockets = java.lang.reflect.Array.newInstance(Class.forName('java.net.DatagramSocket'), 0);

    % This uses Java's instrumentation API to find objects in memory
    % Requires JVM agent (this may not be installed in the MATLAB JVM by default)
    try
        % Instrumentation is needed to list all Java objects in JVM memory
        instr = java.lang.instrument.Instrumentation();
        sockets = instr.getAllLoadedClasses();
    catch
        % If instrumentation is not available, we can use other approaches
        % Unfortunately, full JVM object discovery is restricted without it
        disp('JVM instrumentation not available to discover active sockets.');
    end
    
    % Loop through the found objects and find open DatagramSockets
    for i = 1:length(sockets)
        if isa(sockets(i), 'java.net.DatagramSocket')
            socketObj = sockets(i);
            try
                % Use reflection to access the port number
                socketClass = socketObj.getClass();
                portField = socketClass.getDeclaredField('port');
                portField.setAccessible(true);
                portNumber = portField.get(socketObj);

                % If the port matches, close the socket
                if portNumber == port
                    disp(['Found open DatagramSocket on port: ', num2str(port)]);
                    socketObj.close();
                    disp('Socket closed successfully.');
                    return;
                end
            catch ME
                disp(['Error while accessing socket details: ', ME.message]);
            end
        end
    end

    disp('No active DatagramSocket found using the specified port.');
end
