function [socket,packet] = createUDPSocket   
import java.net.DatagramSocket
    import java.net.DatagramPacket
    import java.lang.reflect.Array

    %% Configuration Parameters
    port = 8888;            % UDP port to listen on
    bufferSize = 16384;       % Size of the buffer for incoming datagrams (in bytes)
    socketTimeout = 50;      % Socket timeout in milliseconds

    %% Initialize the DatagramSocket
    try
        socket = DatagramSocket(port);
        socket.setSoTimeout(socketTimeout);        % Set short timeout for non-blocking
        socket.setReceiveBufferSize(bufferSize);   % Adjust socket's receive buffer size
        actualBufferSize = socket.getReceiveBufferSize();
        disp(['UDP Receiver initialized on port ', num2str(port)]);
        disp(['Socket receive buffer size set to ', num2str(actualBufferSize), ' bytes']);
    catch ME
        error(['Failed to create DatagramSocket: ', ME.message]);
    end

    %% Create the DatagramPacket Buffer
    buffer = Array.newInstance(java.lang.Byte.TYPE, bufferSize);
    packet = DatagramPacket(buffer, bufferSize);