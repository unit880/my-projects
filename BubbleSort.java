public class BubbleSort {

    public static void main(String[] args) {
        
        String[] languages = 
        {
            "Assembly",  
            "FORTRAN",
            "Lisp",
            "COBOL",
            "ALGOL",
            "Pascal",
            "C",
            "Ada",
            "Smalltalk",
            "C++",
            "BASIC",
            "Java",
            "Perl",
            "Python",
            "Ruby",
            "Haskell",
            "Scala",
            "Clojure",
            "Swift",
            "Go"
        };
        
        sort(languages);
        
        //write a loop that prints the languages array
        for (int i=0; i<languages.length; i++) {
            System.out.println(languages[i]);
        }
    }
    
    // Bubble sort
    public static void sort(String[] arr){
        // Boolean to pass through and check if they're sorted, if they are break out of the loop
        boolean notSorted = true;
        while (notSorted) {
            // Boolean to check to see if any of the positions have been swapped, if not, we're gonna break out of the loop
            boolean swapped = false;
            // Loop through entire array
            for (int i=0; i<arr.length-1; i++) {
                // If the lower value is supposed to move up, move it up
                if (arr[i].compareToIgnoreCase(arr[i+1]) > 0) {
                    String temp = arr[i];
                    arr[i] = arr[i+1];
                    arr[i+1] = temp;
                    // we swapped, so we're not breaking out this loop
                    swapped = true;
                }
            }
            // If we didn't swap any, we're done looping and the sort's done
            if (swapped == false) {
                notSorted = false;
            }
        }
    }
    
    // Perform binary search on a sorted array
    public static int searchLanguages(String[] arr, String lang){
        int upperBound = arr.length;
        int midpoint = upperBound/2;
        int lowerBound = 0;
        int foundIndex = -1;
        int result;
                    // "Ruby".compareToIgnoreCase("Haskell")
                    // == 10, because "Ruby" > "Haskell" alphabetically
        
        do{
            System.out.println("Current Upper bound: " + upperBound);
            System.out.println("Current midpoint: " + midpoint);
            System.out.println("Current Lower Bound: " + lowerBound);
            result = lang.compareToIgnoreCase(arr[midpoint]);
            if (result == 0) {// if we find the string at the midpoint
                foundIndex = midpoint;
            } else if (result > 0) {
                lowerBound = midpoint;
                midpoint = (upperBound + midpoint) / 2;
            } else {
                int newMidpoint = (upperBound - midpoint) / 2;
                upperBound = midpoint;
                midpoint = newMidpoint;
            }
        }while((result != 0) && (midpoint != lowerBound));
        
        return foundIndex;
    }
    
}
