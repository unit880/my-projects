/* Name: Jeffrey Meszaros
 * Date: 4 - 11 - 2016 
 * Filename: NumberNode.java
 * Description: Class that holds operands, based on ENode.
 */
public class NumberNode extends ENode {
    
    private double data;
    
    // Constructors
    
    NumberNode() {
        data = 0;
    }
    
    NumberNode(double data) {
        this.data = data;
    }
    
    // Methods
    
    public double value() {
        return data;
    }
}
