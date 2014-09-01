---
layout: post
title: Memory Management in C++ 11
categories: programming cpp
---

This article introduces low-level memory management techniques to programmers who are familiar with high-level languages such as Java or Python. It describes how memory management works in C++ and introduces pointers and smart pointers.

> In common parlance, the word 'memory' is ambiguous. Whenever this article uses the word 'memory', it refers to volatile short term storage, e.g. the computer's RAM, CPU cache, page file/swap partition- **not the file system on the hard drive**. 

## Introduction to Memory

Computer memory can be abstracted as a number of *locations* that are labeled by *addresses*. The UTF-8 string "Hello World" might be stored in memory as follows:

    content: | H | e | l  | l  | o  | ' ' | W  | o  | r  | l  | d  | '\0' |
    address: | 0 | 8 | 16 | 32 | 40 | 48  | 56 | 64 | 82 | 90 | 98 | 106  |

> The character '\0' is called the null terminator and marks the end of a C-style string.

> The addresses are incremented by 8 because UTF-8 characters are 8 bits long.

> In reality, the memory addresses are not nice small numbers like 0, 8, 16..., since the operating system is already using the first several hundred million bytes of memory. Expect to debug memory addresses like 0x4004dfd2 and 0x8048b91.

In a low-level language like C, this string can be read from memory using a simple loop:

1. Look at the memory address at the start of the string (in the example, address 0).
1. Read the character at the current address. If the character is the null terminator, stop now.
1. Look at the address 8 bits forward (since UTF-8 characters are stored as 8 bits) and repeat step 2.

This can be implemented in C as follows:

{% highlight C %}
int main() {
    // Create the Hello World string and store the address of the first character in a pointer called my_string
    char *hello_world_pointer = "Hello World";

    int offset = 0;
    do {
        // Read the character under the "cursor" using the dereference operator
        char current_char = *(hello_world_pointer + offset);

        // Check for the null terminator
        bool current_char_is_not_null_terminator = (current_char == '\0');

        // If the current character is not a null terminator, print it and advance the "cursor" by the number of bits in a char
        if (current_char_is_not_null_terminator) {
            printf("%c", current_char);
            offset += sizeof(char);
        }
    } while (current_char_is_not_null_terminator)
}
{% endhighlight %}

> The above code is a contrived example. Please don't ever print a string this way.

## Pointers

In the previous example, `hello_world_pointer` is a *pointer*. The value of `hello_world_pointer` is the memory address of the first character of the string we created. The string is then accessed  by *dereferencing* the pointer, which tells the computer to fetch whatever is at the pointer address. In C++, the dereference operator is `*`. You might find this confusing because `*` is also used to declare pointers.

C-style strings are a special case in that creating the string also created a pointer to the string. This normally doesn't happen in legacy C++ code. Instead, pointers have to be manually retrieved using the *address-of operator*. In C++, the address-of operator is `&`. You might find this confusing because `&` is also used to declare references.

The syntax for creating and dereferencing pointers in C++ is simple, if slightly unintuitive:

{% highlight C++ %}
#include <cstdio>
#include <string>

// This is a class we'll use in the example.
class Cat {
    public:
        Cat(std::string name) {
            this->name = name;
        }

        void meow() {
            std::printf("%s says meow!", this->name);
        }
    private:
        std::string name;
};

int main() {
    // Here we have a primitve
    int answer = 42;

    // Set the value of the int pointer called answer_pointer to the address of the variable called answer
    int* answer_pointer = &answer;

    // Due to a quirk of the C++ programming language, the whitespace around the * doesn't matter when creating a pointer
    // All of these lines have the exact same semantic meaning 
    int* answer_pointer = &answer;
    int * answer_pointer = &answer;
    int *answer_pointer = &answer;

    // Just pick one style and stick with it. The rest of the examples will use the first style.

    // Now that we have a pointer, we can do stuff with it.
    // We could use it directly, though that's not very useful...
    std::printf("The memory address of answer is: %p", answer_pointer);
    // We can dereference the pointer, which gives us the original primitive
    std::printf("The value of answer is: &d", *answer_pointer);
    // That was a really roundabout way of doing things. We could just used answer directly!
    std::printf("The value of answer is: &d", answer);

    // We can use pointers with objects, too!
    Cat felix("Felix");
    Cat* felix_pointer = &felix;

    // We could dereference the pointer to call the object's member functions...
    (*felix_pointer).meow();
    // ...but there's a special member access operator for use with pointers that's shorter and easier to use
    felix_pointer->meow();
    // This still doesn't seem very useful! We could just use the object directly!
    felix.meow();

    return 0;
}
{% endhighlight %}

## Why Use Pointers?

Pointers seem useless. All they've done so far is make the code more verbose and harder to read. Why would anyone ever use them? Java and Python don't have pointers, and those are really popular and useful languages!

The infalliable [James Mickens](http://research.microsoft.com/en-us/people/mickens/) explains it better than I ever could.

>You might ask, “Why would someone write code in a grotesque language that exposes raw memory addresses? Why not use a modern language with garbage collection and functional programming and free massages after lunch?” Here’s the answer: Pointers are real. They’re what the hardware understands. Somebody has to deal with them. You can’t just place a LISP book on top of an x86 chip and hope that the hardware learns about lambda calculus by osmosis. Denying the existence of pointers is like living in ancient Greece and denying the existence of Krackens and then being confused about why none of your ships ever make it to Morocco, or Ur-Morocco, or whatever Morocco was called back then. Pointers are like Krackens—real, living things that must be dealt with so that polite society can exist.

Source: [*The Night Watch*](http://research.microsoft.com/en-us/people/mickens/thenightwatch.pdf)


## Pass By Value and Pass By Reference

A huge benefit of using pointers is that they enable more efficient use of memory. In C++, passing arugments to a function performs *pass-by-value*. A copy of the argument is made in memory. Passing a pointer as a function argument performs *pass by reference* instead, which is more memory efficient. Compare the following code snippets. 

{% highlight C++ %}
#include <vector>

class Cat {
    public:
        Cat(std::string name) {
            this->name = name;
        }

        void meow() {
            std::printf("%s says meow!", this->name);
        }

        void eat() {
            std::printf("%s eats some food.", this->name);
        }

        void walk() {
            std::printf("%s goes for a walk.", this->name);
        }
    private:
        std::string name;
};

std::vector<Cat> feed_all(std::vector<Cat> cats) {
    for (Cat cat : cats) {
        cat.eat();
    }
    return cats;
}

std::vector<Cat> rest_all(std::vector<Cat> cats) {
    for (Cat cat : cats) {
        cat.walk();
    }
    return cats;
}

std::vector<Cat> talk_to_all(std::vector<Cat> cats) {
    for (Cat cat : cats) {
        cat.meow();
    }
    return cats;
}

int main() {
    std::vector<Cat> siamese_cats();
    Cat si("Si");
    siamese_cats.push_back(si);
    Cat am("Am");
    siamese_cats.push_back(am);

    siamese_cats = feed_all(siamese_cats);
    siamese_cats = walk_all(siamese_cats);
    siamese_cats = talk_to_all(siamese_cats);
    
    return 0;
}
{% endhighlight %}

The above example performs the following steps:

1. Create a vector of two cats in memory. Let's call this vector siamese_cats0.
1. Create a copy of `siamese_cats0` and pass the copy to `feed_all`. Let's call the copy `siamese_cats1`.
1. Do some work with `siamese_cats1`.
1. Return `siamese_cats1` from `feed_all` to `main` and overwrite `siamese_cats0` with `siamese_cats1`.
1. Create a copy of `siamese_cats1` and pass the copy to `feed_all`. Let's call the copy `siamese_cats2`.
1. Do some work with `siamese_cats2`.
1. Return `siamese_cats1` from `feed_all` to `main` and overwrite `siamese_cats1` with `siamese_cats2`.
1. Create a copy of `siamese_cats2` and pass the copy to `feed_all`. Let's call the copy `siamese_cats3`.
1. Do some work with `siamese_cats3`.
1. Return `siamese_cats1` from `feed_all` to `main` and overwrite `siamese_cats2` with `siamese_cats3`.

This code made four copies of the vector and at times there were two copies of the vector in memory. Pointers and pass-by-reference are more efficient and easier to read:

{% highlight C++ %}
#include <vector>

class Cat {
    public:
        Cat(std::string name) {
            this->name = name;
        }

        void meow() {
            std::printf("%s says meow!", this->name);
        }

        void eat() {
            std::printf("%s eats some food.", this->name);
        }

        void walk() {
            std::printf("%s goes for a walk.", this->name);
        }
    private:
        std::string name;
};

void feed_all(std::vector<Cat>* cats) {
    for (Cat cat : *cats) {
        cat.eat();
    }
}

void rest_all(std::vector<Cat>* cats) {
    for (Cat cat : *cats) {
        cat.walk();
    }
}

void talk_to_all(std::vector<Cat>* cats) {
    for (Cat cat : *cats) {
        cat.meow();
    }
}

int main() {
    std::vector<Cat> siamese_cats();
    Cat si("Si");
    siamese_cats_pointer.push_back(si);
    Cat am("Am");
    siamese_cats_pointer.push_back(am);

    siamese_cats_pointer = &siamese_cats;

    feed_all(siamese_cats_pointer);
    walk_all(siamese_cats_pointer);
    talk_to_all(siamese_cats_pointer);
    
    return 0;
}
{% endhighlight %}

Now the code performs the following steps:

1. Create a vector of two cats in memory. Let's call this vector siamese_cats0.
1. Use the address-of operator to creator a pointer to siamese_cats0. Let's call this siamese_cats_pointer0.
1. Create a copy of siamese_cats_pointer0 and pass the copy to `feed_all`. Let's call the copy siamese_cats_pointer1.
1. Dereference siamese_cats_pointer1 and do some work with siamese_cats0.
1. Create a copy of siamese_cats_pointer0 and pass the copy to `walk_all`. Let's call the copy siamese_cats_pointer2.
1. Dereference siamese_cats_pointer2 and do some work with siamese_cats0.
1. Create a copy of siamese_cats_pointer0 and pass the copy to `talk_to_all`. Let's call the copy siamese_cats_pointer3.
1. Dereference siamese_cats_pointer3 and do some work with siamese_cats0.

Now instead of four vectors, we have one vector and four pointers. The memory usage is significantly better off now because pointers are *tiny*. (A pointer is the same size as an int). The memory savings from not making any copies of the vector far outweigh the increased memory cost of copying and managing pointers. As an added bonus, the pointers version of this code is a bit simpler and easier to read.

## The Stack and the Heap

So far, this article has treated the computer's memory as a big blob where data is stored while a program runs. A more accurate view of memory is that there are multiple places where the data can be stored. There's the *stack* and the *heap*. The implementation details of the stack and the heap are beyond the scope of this article, but the behavior of the heap versus the stack is important to memory management.

> This section of the article is simplified to make it easier to digest. If you want to know how memory *really* works ask someone much, much smarter than me.

The *stack* is easy to use. It automatically allocates memory when a variable enters scope, and deallocates that memory when the variable falls out of scope. The syntax `TypeName variable_name(<constructor parameters>);` will allocate a variable on the stack. All of the examples so far have allocated memory on the stack.

{% highlight C++ %}
#include <cstdio>
#include <string>

class Cat {
    public:
        Cat(std::string name) {
            this->name = name;
        }

        void meow() {
            std::printf("%s says meow!", this->name);
        }
    private:
        std::string name;
};

void meow_for_me(std::string name) { // name enters scope and is pushed onto the stack
    Cat cat_on_stack(name); // cat_on_stack enters scope and is pushed onto the stack
    cat_on_stack.meow();
} // name and cat_on_stack fall out of scope and are popped off the stack

int main() {
    meow_for_me("Crookshanks");
    meow_for_me("Tom");
    meow_for_me("Garfield");
    // No cats on the stack and no wasted memory

    return 0;
}

{% endhighlight %}

The *heap* is different. Although it also automatically allocates memory when a variable enters scope, it will **not** deallocate that memory when the variable leaves scope! The syntax `pointer_name = new TypeName(<constructor parameters>)` will allocate an object on the heap and return a pointer to the object.

{% highlight C++ %}
#include <cstdio>
#include <string>

class Cat {
    public:
        Cat(std::string name) {
            this->name = name;
        }

        void meow() {
            std::printf("%s says meow!", this->name);
        }
    private:
        std::string name;
};

void meow_for_me(std::string name) { // name enters scope and is pushed onto the stack
    // Note the new keyword used here
    cat_on_heap = new Cat(name); // cat_on_heap enters scope and cat_on_heap is allocated on the heap
    cat_on_heap.meow();
} // name and cat_on_heap fall out of scope. name was on the stack and has been popped off the stack, but cat_on_heap was on the heap and a Cat still exists in memory!

int main() {
    meow_for_me("Crookshanks");
    meow_for_me("Tom");
    meow_for_me("Garfield");
    // Three cats on the heap and three memory leaks

    return 0;
}
{% endhighlight %}

The above code has a *memory leak*. Each time `meow_for_me` was called, memory was allocated on the heap but was not released when the program no longer required the memory. In this program, the amount of memory that was leaked was miniscule. In a more complex program, a memory leak can add up over time and eventually crash the computer. The correct way to fix this is to use the `delete` operator to manually deallocate the memory on the heap. Every use of the `new` operator must have a matching use of the `delete` operator. 

{% highlight C++ %}
#include <cstdio>
#include <string>

class Cat {
    public:
        Cat(std::string name) {
            this->name = name;
        }

        void meow() {
            std::printf("%s says meow!", this->name);
        }
    private:
        std::string name;
};

void meow_for_me(std::string name) { // name enters scope and is pushed onto the stack
    cat_on_heap = new Cat(name); // cat_on_heap enters scope and cat_on_heap is allocated on the heap
    cat_on_heap.meow();
    delete cat_on_heap; // cat_on_heap is deallocated
} // name falls out of scope and is popped off the stack.

int main() {
    meow_for_me("Crookshanks");
    meow_for_me("Tom");
    meow_for_me("Garfield");
    // No cats on the heap and everyone is happy

    return 0;
}
{% endhighlight %}

Now everything is fine- but the `delete` operator introduces another type of memory bug. In a multi-threaded program, it's possible to delete a heap pointer in one thread without notifying the other threads. This is difficult to show in an example that will fit on this web page, but imagine the following sequence of events.

1. A program spawns two threads, Thread0 and Thread1.
1. Thread0 allocates a Cat named Snowball on the heap.
1. Thread0 passes a pointer to Snowball to Thread1.
1. Thread0 deletes Snowball. 
1. Thread1 dereferences the Snowball pointer. By pure luck, Snowball hasn't been overwritten in memory yet, so Thread1 reads Snowball just fine.
1. Some time passes. Thread0 allocates a Cat named Cheshire on the heap, and by coincidence Cheshire is allocated to the segment of memory Snowball was allocated to.
1. Thread1 dereferences the Snowball pointer. It blindly reads the Cheshire data instead of the Snowball data, and the user is confused why the wrong cat picture is showing up on their screen.
1. Thread0 deletes Cheshire.
1. More time passes. The user opens up the program's 3D Cat View feature. By coincidence, a 3D model of a cat is allocated to the segment of memory Snowball and Cheshire were allocated to.
1. Thread1 dereferences the Snowball pointer. It blindly reads in part of the 3D model. Thread1 was expecting a Cat object and instead is blindly reading random bytes. The program crashes for aparently no reason, hours after the bug which caused the issue. The user reports a bug in the 3D Cat View feature which the developers can't reproduce. Everyone involved is very unhappy.

This type of bug is called a *dangling pointer* and is very difficult to debug. This is what drives system programmers to madness.

## Why Use the Heap?

The heap is just like pointers- seemingly useless and error-prone! Why not use the stack for everything?

I was not entirely truthful in the previous section. There isn't a single stack- there's one stack per thread, and those stacks can't share information. If a program needs several threads that can talk to each other, the theads must allocate memory on the heap and pass pointers to each other. This is important because multithreading is a common and highly effective technique used to write really fast programs.

Also, the stack is vulnerable to [stack overflow](http://en.wikipedia.org/wiki/Stack_overflow) under some conditions, such as if a very large array is allocated on the stack. Using the heap is necessary in these cases.

## Memory Management Sucks!

Yup.

## Is there any hope?

Yes! C++11 introduced new types of pointers that automate most of the memory management work. They're called smart pointers.

## Smart Pointers

### Shared Pointers

Shared pointers are pointers that track the number of places they are referenced at and automatically delete themselves when there are no remaining references. They have a small performance cost compared to normal pointers, which is usually worth the tradeoff for automatic memory management. A shared pointer can be created in two ways. The first way is to use `std::make_shared<Type>`, which creates a new instance of `Type`.

{% highlight C++ %}
#include <cstdio>
#include <string>
#include <memory>

class Cat {
    public:
        Cat(std::string name) {
            this->name = name;
        }

        void meow() {
            std::printf("%s says meow!", this->name);
        }
    private:
        std::string name;
};


int main() {
    // Create a Cat on the heap and get a shared pointer
    std::shared_ptr<Cat> tony = std::make_shared<Cat>("Tony");

    // We can use the shared pointer with the exact same syntax as a normal pointer
    tony->meow();
    (*tony).meow();

    // No need to use the delete operator here- the Cat will automatically deallocated when tony falls out of scope
}
{% endhighlight %}

To obtain a shared pointer to an existing instance of a class, the class must extend `std::enable_shared_from_this<Type>`:

{% highlight C++ %}
#include <cstdio>
#include <string>
#include <memory>

class Cat : public std::enable_shared_from_this<Cat> {
    public:
        Cat(std::string name) {
            this->name = name;
        }

        void meow() {
            std::printf("%s says meow!", this->name);
        }
    private:
        std::string name;
};


int main() {
    // Create a Cat on the heap and get a shared pointer
    std::shared_ptr<Cat> tony = std::make_shared<Cat>("Tony");

    // We can create another shared pointer to the same Cat
    std::shared_ptr<Cat> tiger = tony.shared_from_this();

    // DO NOT DO THE FOLLOWING
    Cat scratchy("Scratchy");
    std::shared_ptr<Cat> scratchy_pointer_0 = scratchy.shared_from_this();
    std::shared_ptr<Cat> scratchy_pointer_1 = scratchy.shared_from_this();
    // scratchy_pointer_0 and scratchy_pointer_1 are not aware of each other. If one of the pointers is deleted, scratchy will be deallocated and the other pointer will become a dangling pointer.
}
{% endhighlight %}

### Weak Pointers

### Unique Pointers
