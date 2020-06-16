/* Name: Jeffrey Meszaros
 * Date: 4 - 11 - 2016
 * Filename: OperatorNode.java
 * Description: Class that contains operators, based on ENode.
 */
public class OperatorNode extends ENode {
    
    private String operator;
    private ENode left;
    private ENode right;
    
    // Constructors 
    
    OperatorNode() {
        operator = null;
    }
    
    OperatorNode(String operator) {
        this.operator = operator;
    }
    
    // Getters and setters
    
    public String getOperator() {
        return operator;
    }
    
    public ENode getLeft() {
        return left;
    }
    
    public ENode getRight() {
        return right;
    }
    
    public void setOperator(String operator) {
        this.operator = operator;
    }
    
    public void setLeft(ENode left) {
        this.left = left;
    }
    
    public void setRight(ENode right) {
        this.right = right;
    }
    
    // Methods
    
    // Method for getting the value of an operator node
    public double value() {
        // Initial declarations
        String[] opArr = {"^", "*", "/", "+", "-"};
        ENode leftNode = getLeft();
        ENode rightNode = getRight();
        double leftValue = leftNode.value();
        double rightValue = rightNode.value();
        
        // Determines which operator to use based on index.
        if (operator.equals(opArr[0])) {
            return Math.pow(leftValue, rightValue);
        } else if (operator.equals(opArr[1])) {
            return leftValue * rightValue;
        }  else if (operator.equals(opArr[2])) {
            return leftValue / rightValue;
        }  else if (operator.equals(opArr[3])) {
            return leftValue + rightValue;
        }  else if (operator.equals(opArr[4])) {
            return leftValue - rightValue;
        } else {
            return 0;
        }
    }
}
