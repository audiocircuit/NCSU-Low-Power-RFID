/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package clientlowpower;


import gnu.io.CommPort;
import gnu.io.CommPortIdentifier;
import gnu.io.NoSuchPortException;
import gnu.io.PortInUseException;
import gnu.io.SerialPort;
import gnu.io.UnsupportedCommOperationException;
import java.awt.FlowLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.File;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import javax.swing.JButton;

import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JTextArea;
import javax.swing.JTextField;
/**
 *
 * @author deathmonkey
 */
public class ClientLowPower implements ActionListener
{
    JFrame gui = new JFrame("Low Power Client");
    JPanel guiPanel = new JPanel();
    
    JButton powerState = new JButton("Power On");
    JButton serialConnected = new JButton("Open Serial Line");
    JButton sensorOne = new JButton("Sensor One");
    JButton sensorTwo = new JButton("Sensor Two");
    JButton sensorThree = new JButton("Sensor Three");
    
    JLabel serialConnectedLabel = new JLabel("Not Connected");
    JLabel powerStateLabel = new JLabel("    Powered Off    ");
    JLabel sensorOneLabel = new JLabel("Sensor One Not Calibrated");
    JLabel sensorTwoLabel = new JLabel("Sensor Two Not Calibrated");    
    JLabel sensorThreeLabel = new JLabel("Sensor Three Not Calibrated");
    
    JTextField errorField = new JTextField(15);
    JTextField sensorOneField = new JTextField(15);
    JTextField sensorTwoField = new JTextField(15);
    JTextField sensorThreeField = new JTextField(15);
    
    JLabel sensorOneLabelField = new JLabel("Sensor One");
    JLabel sensorTwoLabelField = new JLabel("Sensor Two");    
    JLabel sensorThreeLabelField = new JLabel("Sensor Three");
    
    FlowLayout layout = new FlowLayout();
    
    File sensorOneFile = new File("SensorOne.txt");
    File sensorTwoFile = new File("SensorTwo.txt");
    File sensotThreeFile = new File("SensorThree.txt");
      
    public ClientLowPower()
    {
        gui.setSize(210, 500);
        guiPanel.add(serialConnectedLabel);
        guiPanel.add(serialConnected);
        guiPanel.add(powerStateLabel);
        guiPanel.add(powerState);
        guiPanel.add(sensorOneLabel);
        guiPanel.add(sensorOne);
        guiPanel.add(sensorTwoLabel);
        guiPanel.add(sensorTwo);       
        guiPanel.add(sensorThreeLabel);
        guiPanel.add(sensorThree);   
        guiPanel.add(new JLabel("    Error     "));  
        guiPanel.add(errorField);
        guiPanel.add(sensorOneLabelField);
        guiPanel.add(sensorOneField);
        guiPanel.add(sensorTwoLabelField);
        guiPanel.add(sensorTwoField);
        guiPanel.add(sensorThreeLabelField);
        guiPanel.add(sensorThreeField);
        errorField.setText("No Error");
        gui.add(guiPanel);
        gui.setVisible(true);
        gui.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        
        powerState.addActionListener(this);
        serialConnected.addActionListener(this);
        sensorOne.addActionListener(this);
        sensorTwo.addActionListener(this);
        sensorThree.addActionListener(this);
    }

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) 
    {
        // TODO code application logic here
        new ClientLowPower();
        
    }

    @Override
    public void actionPerformed(ActionEvent e) 
    {
        if(e.getSource() == powerState)
        {
            powerStateLabel.setText("     Power On     ");
            
            
        }
        else if(e.getSource() == serialConnected)
        {
            try
            {
                CommPortIdentifier portIdentifier = CommPortIdentifier.getPortIdentifier("/dev/ttyACM0");
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
                        serialConnectedLabel.setText("  Connected  ");

                    } 
                    else 
                    {
                        System.out.println("Error: Only serial ports are handled");
                    }
                }
            }
            catch(NoSuchPortException exception)
            {
                exception.printStackTrace();
            } 
            catch (PortInUseException exception) 
            {
                exception.printStackTrace();
            } 
            catch (UnsupportedCommOperationException exception) 
            {
                exception.printStackTrace();
            } 
            catch (IOException exception) 
            {
                exception.printStackTrace();
            }
            serialConnectedLabel.setText("  Connected  ");
        }
        else if(e.getSource() == sensorOne)
        {
            sensorOneLabel.setText("Sensor One Calibrated");
        }
        else if(e.getSource() == sensorTwo)
        {
            sensorTwoLabel.setText("Sensor Two Calibrated");
        }
        else if(e.getSource() == sensorThree)
        {
            sensorThreeLabel.setText("Sensor Three Calibrated");
        }
    }
    
    
    private static class SerialWriter implements Runnable 
    {
        public OutputStream out;
        public String string = null;
        public boolean writeState;

        public SerialWriter(OutputStream out) 
        {
            this.out = out;
            writeState = false;
        }

        @Override
        public void run() 
        {
            try 
            {
                while(!writeState);
                int c = 0;
                while ((c = System.in.read()) > -1) 
                {
                    while(!writeState);
                    this.out.write(Byte.parseByte(string));
                    writeState = false;
                }
            } 
            catch (IOException e) 
            {
                e.printStackTrace();
            }
        }
    }

    
    private static class SerialReader implements Runnable 
    {

        InputStream in;

        public SerialReader(InputStream in) 
        {
            this.in = in;
        }

        @Override
        public void run() 
        {
            byte[] buffer = new byte[1024];
            int len = -1;
            try 
            {
                while ((len = this.in.read(buffer)) > -1) 
                {
                    System.out.print(new String(buffer, 0, len));
                    
                }
            } 
            catch (IOException e) 
            {
                e.printStackTrace();
            }

        }
    }

    
}
