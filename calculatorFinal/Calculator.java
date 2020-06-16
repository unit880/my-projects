
import java.util.ArrayList;
import java.util.Scanner;
import java.util.Stack;

/* Name: Jeffrey Meszaros
 * Date: 4 - 11 - 2016
 * Filename: Calculator.java
 * Description: Calculate things! Fun!
 * Functions: isOperand(), isOperator(), isExpression(), hasPriority(), getTree()
 * Type "exit" or ctrl+c to break out!
 */

public class Calculator {
    public static void main(String[] args) {
        
        // Initial declarations
        Scanner scan = new Scanner(System.in);
        String input = "";
        String[] inputArr;

        // Main loop
        while (!input.toLowerCase().equals("exit")) {
            input = scan.nextLine();
            inputArr = input.split(" ");
            if (isExpression(inputArr)) {
                OperatorNode hereItIs = getTree(inputArr);
                System.out.println(hereItIs.value());
            } else if (!input.equals("exit")) {
                System.out.println("That was an invalid expression.");
            }
        }

        scan.close();
    }
    
    // Function to check if something is numeric
    public static boolean isOperand(String input) {
        boolean isOperand = true;
        try { 
            double someDouble = Double.parseDouble(input); 
        } catch(NumberFormatException e) {
            isOperand = false;
        }
        return isOperand;
    }
    
    // Function to check if something is an operator
    public static boolean isOperator(String input) {
        String[] opArr = {"^", "*", "/", "+", "-"};
        boolean isOperator = false;
        for (int i=0; i<=opArr.length-1; i++) {
            if (opArr[i].equals(input)) {
                isOperator = true;
            }
        }
        return isOperator;
    }
    
    // Function to check if an expression is valid
    public static boolean isExpression(String[] inputArr) {
        boolean isExpression = true;
        
        if (inputArr.length == 1) {
            isExpression = false;
        }
        
        for (int i=0; i<=inputArr.length-1; i=i+2) {
            if (i != inputArr.length-1) {
                if (!isOperand(inputArr[i]) || !isOperator(inputArr[i+1])) {
                    isExpression = false;
                }
            } else if (i == inputArr.length-1) {
                if (!isOperand(inputArr[i])) {
                    isExpression = false;
                }
            } else {
                System.out.println("Error in isExpression()\nSomething bungled up the indexes");
            }
        } 
        return isExpression;
    }
    
    // Function for getting the priority of operators
    public static boolean hasPriority(String firstOp, String secondOp) {
        // Wish there was a good way to do it besides this, but I can't find it
        ArrayList<String> opArr = new ArrayList<String>();
        opArr.add("-");
        opArr.add("+");
        opArr.add("/");
        opArr.add("*");
        opArr.add("^");

        // Start off assuming firstOp isn't greater than secondOp
        boolean hasPriority = false;
        
        if (opArr.indexOf(firstOp) > opArr.indexOf(secondOp)) {
            hasPriority = true;
        }
        
        return hasPriority;
    }
    
    // Function that builds the binary trees for calculations
    public static OperatorNode getTree(String[] inputArr) {
        // Initial declarations
        Stack<ENode> operandStack = new Stack<ENode>();
        Stack<String> operatorStack = new Stack<String>();
        OperatorNode operator = new OperatorNode();
        
        for (int i=0; i<=inputArr.length-1; i++) {
            // If it's an operand, add it to the the operandStack
            if (isOperand(inputArr[i])) {
                double num = Double.parseDouble(inputArr[i]);
                NumberNode operand = new NumberNode(num);
                operandStack.push(operand);
            // If it's an operator, we have to look at it further
            } else if (isOperator(inputArr[i])) {
                // If the stack is empty or the one currently on top has lower priority, add the new one to the stack
                if (operatorStack.isEmpty() ||
                    hasPriority(inputArr[i], operatorStack.peek())) {
                    operatorStack.push(inputArr[i]);
                // If the one on top has a greater priority, pop it and the top two operands to create a new OperatorNode
                } else if (!hasPriority(inputArr[i], operatorStack.peek())) { 
                    String poppedOp = operatorStack.pop();
                    operator = new OperatorNode(poppedOp);
                    operator.setRight(operandStack.pop());
                    operator.setLeft(operandStack.pop());
                    operandStack.push(operator);
                    operatorStack.push(inputArr[i]);
                }
            // If it's not an operator or operand, something got messed up
            } else {
                System.out.println("Error in getTree()\nInput was not operator or operand");
            }
        }
        
        // Make sure the operator stack is empty at the end of everything
        while (!operatorStack.isEmpty()) { 
            String poppedOp = operatorStack.pop();
            operator = new OperatorNode(poppedOp);
            operator.setRight(operandStack.pop());
            operator.setLeft(operandStack.pop());
            operandStack.push(operator);
        }
        return operator;
    }
}
