# LIFO-and-FIFO-Data-Structures
In audio, we often use std::vector and arrays for holding data. It is a flexible data structure that allows random reads and writes. However, we may want to restrict the processing order. In this case, we may use other STL container classes or we may create data structures such as stacks and queues.  Two common data structures in computer science are LIFO (last-in-first-out) and FIFO (first-in-first-out).

# Last-In-First-Out

In a LIFO data structure, the newest element added to the container will be processed first. Sometimes this will be called a stack and is usually pictured as below. The new element is always added at the end of the stack. There are two basic operations that a LIFO needs to allow:

- push - append an element to the end of the container

- pop - remove the most recent element from the container

  <img src= "https://i.stack.imgur.com/fUtR1.png">
  
 The LIFO data structure can be thought of as analogous to a deck of cards that you add to the top of and draw from the top of.

A Basic LIFO Data Structure
The following code should outline a basic LIFO as we have discussed so far.

````
class BasicLIFO
{
    private:
        /*use a vector to store the data...*/
        vector<float> containerLIFO;

        bool isEmpty()
        {
            /*checks if the container is empty or not...
            we need this function as our container is private.*/
            return containerLIFO.empty();
        }
    
    public:
    
        void push(float x)
        {
            /*append value to vector...*/
            containerLIFO.push_back(x);
        }
    
        bool pop()
        {
            /* check whether the queue is empty or not... */
            if (isEmpty())
            {
                return false;
            }
            /* delete an element from the queue...*/
            containerLIFO.pop_back();
            /*return true if the operation is successful...*/
            return true;
        }
};
````

There are more advanced LIFO structures that are generic, multi-channeled, can handle multiple users, multiple readers or can still have methods that handle internal sorting and searching.

LIFOs are useful when a program needs to access the most recent information entered. Stacks are important in algorithms involving backtracking. While this is not fundamental to DSP it is common to use this in other parts of a program such as File Management or parameter parsing. I highly recommend you come to grips with std::stack for solving interview related LIFO questions.

# First-In-First-Out
In a FIFO data structures the first element added to the container will be processed first. There are two basic operations that a FIFO needs to allow:

- enqueue - append an element to the end of the container
- dequeue - remove the first element from the container

This is represented graphically below. The container is a number of contiguous boxes. A box can be added to only one end and a box can be taken from only the opposite end. Think of it like a conveyor belt.

<img src ="https://i.stack.imgur.com/CqutZ.png">

A Basic FIFO Data Structure

The following code should outline a basic FIFO as we have discussed so far.

````
class BasicFIFO
{
    private:
        /*use a vector to store the data...
        pretend this is an audio buffer....*/
        vector<float> containerFIFO;       
        /*a read index to indicate the start position...*/
        int readIndex;

        bool isEmpty()
        {
            /*checks whether the container is empty or not...*/
            return readIndex >= containerFIFO.size();
        }

    public:
        BasicFIFO()
        {
            /*initialize readIndex position...*/
            readIndex = 0;
        }
    
        bool enqueueValue(float x)
        {
            /*insert an element into the container...
            return true if the operation is successful...*/
            containerFIFO.push_back(x);
            return true;
        }
    
        bool dequeueValue()
        {
            /*increment readIndex...
            return true if the operation is successful...*/
            if (isEmpty())
            {
                return false;
            }
            readIndex++;
            return true;
        }
};

````

This class and the behavior designated by the functions ensures that our data structure has this First In First Out behavior that the name implies. 
