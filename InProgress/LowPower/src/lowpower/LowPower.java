/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package lowpower;

import gnu.io.CommPort;
import gnu.io.CommPortIdentifier;
import gnu.io.NoSuchPortException;
import gnu.io.PortInUseException;
import gnu.io.SerialPort;
import gnu.io.UnsupportedCommOperationException;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

/**
 *
 * @author deathmonkey
 */
public class LowPower {

    public LowPower() {
        super();
    }

    void connect(String portName) throws NoSuchPortException, PortInUseException, UnsupportedCommOperationException, IOException 
    {
        CommPortIdentifier portIdentifier = CommPortIdentifier.getPortIdentifier(portName);
        System.out.println("portIdentifier: " + portIdentifier.toString());
        if (portIdentifier.isCurrentlyOwned()) 
        {
            System.out.println("Error: Port is currently in use");
        } 
        else 
        {
            CommPort commPort = portIdentifier.open(this.getClass().getName(), 2000);
            System.out.println("comPort: "+ commPort.toString());
            if (commPort instanceof SerialPort) 
            {
                SerialPort serialPort = (SerialPort) commPort;
                System.out.println("serialPort: " + serialPort.getName());
                serialPort.setSerialPortParams(9600, SerialPort.DATABITS_8, SerialPort.STOPBITS_1, SerialPort.PARITY_NONE);

                InputStream in = serialPort.getInputStream();
                OutputStream out = serialPort.getOutputStream();

                (new Thread(new SerialReader(in))).start();
                (new Thread(new SerialWriter(out))).start();

            } else {
                System.out.println("Error: Only serial ports are handled");
            }
        }

    }

    private static class SerialReader implements Runnable {

        InputStream in;

        public SerialReader(InputStream in) {
            this.in = in;
        }

        @Override
        public void run() {
            byte[] buffer = new byte[1024];
            int len = -1;
            try {
                while ((len = this.in.read(buffer)) > -1) {
                    System.out.print(new String(buffer, 0, len));
                }
            } catch (IOException e) {
                e.printStackTrace();
            }

        }
    }

    private static class SerialWriter implements Runnable {

        OutputStream out;

        public SerialWriter(OutputStream out) {
            this.out = out;
        }

        @Override
        public void run() {
            try {
                int c = 0;
                while ((c = System.in.read()) > -1) {
                    this.out.write(c);
                }
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        // TODO code application logic here
        try 
        {
            (new LowPower()).connect("/dev/ttyACM0");
        }
        catch( Exception e)
        {
            e.printStackTrace();
        }
    }
}
