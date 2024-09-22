import ballerina/io;
import ballerina/http;

public function main() returns error? {
    io:println("Assignment 1 Client");
    io:println("-------------------------------------");

    Client apiClient = check new;

    showMenu(apiClient);
}

function showMenu(Client apiClient) {
    while (true) {
        io:println("Available Actions:");
        io:println("1. List Programs");
        io:println("2. Add Program");
        io:println("3. Get Program by Program Code");
        io:println("4. Update Program by Program Code");
        io:println("7. List Courses");
        io:println("12. Exit");

        string number = io:readln("Enter your choice: ");
        int|error choice = int:fromString(number);

        match choice {
        1 => {
            listPrograms(apiClient);
        }
        // Use `|` to match more than one value.
        2 => {
            addProgram(apiClient);
        }
        3 => {
            getProgramByprogramCode(apiClient);
        }
        // Use `|` to match more than one value.
        4 => {
            updateProgramByprogramCode(apiClient);
        }
        // Use `|` to match more than one value.
        7 => {
            listCourses(apiClient);
        }
    }
    }
}

function listPrograms(Client apiClient) {
    // Call the corresponding method on the client
    var result = apiClient->/["Programs"];

    if result is Program[] {
        // Loop through array
        foreach var Program in result {
            io:println("Program Code: "+Program.programCode);
            io:println("programTitle: "+Program.programTitle);
            io:println("Faculty & Department: "+Program.facultyAndDeptName);
            io:println("NQF Level: "+Program.nqfQual);
            io:println("Registration Date: "+Program.registrationDate);
            io:println("Courses: ");

            foreach var course in Program.courses {
                io:println("Course Code: "+course.courseCode);
                io:println("Course Name: "+course.courseName);
                io:println("NQF Level: "+course.nqfLevel);
            }

            io:println("-------------------------------");
            io:println("");
        }
    }
    else {
        io:println("Error message: " + result.message());
        io:println(result.cause());
    }
}

function addProgram(Client apiClient) {

    //Get a list of available courses
    var allCourses = apiClient->/["courses"];

    if(allCourses is error){
        io:println("Error retrieving the list of courses");
        return;
    }

    // Collect input from the user
    Program Program = {courses: [], nqfQual: "", facultyAndDeptName: "", programCode: "", programTitle: "", registrationDate: ""};
    Program.programCode = io:readln("Enter Program Code: ");
    Program.nqfQual = io:readln("Enter NQF Level: ");
    Program.facultyAndDeptName = io:readln("Enter Faculty and Deparment Name: ");
    Program.programTitle = io:readln("Enter Program Title: ");
    Program.registrationDate = io:readln("Enter Registration Date: ");

    io:println("----------------------------------");
    io:println("Available Courses to Assign To The Program");

    int courseIndex = 0;

    foreach var course in allCourses {
        io:println(courseIndex.toString() + ": "+course.courseCode+ ": "+course.courseName);
        courseIndex = courseIndex +1;
    }
    
    boolean addMoreCourses = true;
    courseIndex = courseIndex-1;
    while(addMoreCourses){
        io:println("Enter the number of the course to assign (0- " +courseIndex.toString()+ ") or type 'exit' to finish assigning: ");
        var input = io:readln();
        if(input == "exit"){
            break;
        }

        int courseNumber;
        int|error chosenInput = int:fromString(input);

        if(chosenInput is error){
            io:println("Invalid Input. Please Enter a valid Course Number.");
        } else{
            courseNumber = chosenInput;
            Program.courses[Program.courses.length()] = allCourses[courseNumber];
            io:println("Course Assigned");
        }

        io:println("Do you want to add another Course? (yes/no): ");
        var continueInput = io:readln();
        if (continueInput != "yes") {
            addMoreCourses = false;
        }
    }
    
    // Call the corresponding method on the client
    var result = apiClient->/["Programs"].post(Program);
    
    if(result is http:Response){
        io:println(result.statusCode);
        io:println("Program succesfully added.");
    }else{
        io:println("Error Message: " + result.message());
        io:println(result.cause());
    }
}

function getProgramByprogramCode(Client apiClient){
    string programCode = io:readln("Enter Program Code: ");
    
    var result = apiClient->/["Programs"]/[programCode];

    if result is Program {
        io:println("Program Details");
        io:println("----------------------");
        io:println("Program Code: "+result.programCode);
        io:println("Program Title: "+result.programTitle);
        io:println("Faculty and Deparment: "+result.facultyAndDeptName);
        io:println("NQF Level: "+result.nqfQual);
        io:println("Registraion Date: "+result.registrationDate);
        io:println("Courses: ");

        foreach var course in result.courses {
            io:println("Course Code: "+course.courseCode);
            io:println("Course Name: "+course.courseName);
            io:println("NQF Level: "+course.nqfLevel);
        }
    }
    else {
        io:println("Error Message" + result.message());
    }
}

function updateProgramByprogramCode(Client apiClient){
    string programCode = io:readln("Enter Program Code: ");

    //Check if Program exists
    var existingProgram = apiClient->/["Programs"]/[programCode];
    if(existingProgram is error){
        io:println("Program with Program Code: '" +programCode+ "' not found.");
        return;
    }

    Program ProgramToUpdate = existingProgram;

    Program Program = {courses: [], nqfQual: "", facultyAndDeptName: "", programCode: "", programTitle: "", registrationDate: ""};
    Program.programCode = programCode;
    Program.nqfQual = io:readln("Enter NQF Level: ");
    Program.facultyAndDeptName = io:readln("Enter Faculty and Department: ");
    Program.programTitle = io:readln("Enter Program Title: ");
    Program.registrationDate = io:readln("Enter Registration Date: ");

    // Retrieve the existing Program details

    while (true) {
        // Display the current courses and let the user choose which one to update
        int courseIndex = 0;
        while (courseIndex < ProgramToUpdate.courses.length()) {
            Course course = ProgramToUpdate.courses[courseIndex];
            io:println("Course " + courseIndex.toString() + ":");
            io:println("Course Code: " + course.courseCode);
            io:println("Course Name: " + course.courseName);
            io:println("NQF Level: " + course.nqfLevel);
            io:println("--------------------------");
            courseIndex = courseIndex + 1;
        }

        int courseIndexMinusOne = courseIndex - 1;

        io:println("Enter the number of the course to update (0-" + courseIndexMinusOne.toString() + ") or type 'exit' to finish updating: ");
        string userInput = io:readln();

        if (userInput == "exit") {
            io:println("Update operation finished.");
            break;
        }

        int|error input = int:fromString(userInput);

        if(input is error){
            io:println("Invalid Input");
            return;
        } else {
            if (input < 0 || input >= courseIndex){
            io:println("Invalid course number.");
            return;
        }

        // Collect updated course details from the user
        Course updatedCourse = {courseCode: "", courseName: "", nqfLevel: ""};
        updatedCourse.courseCode = io:readln("Enter updated Course Code: ");
        updatedCourse.courseName = io:readln("Enter updated Course Name: ");
        updatedCourse.nqfLevel = io:readln("Enter updated NQF Level: ");

        // Update the selected course
        Program.courses[input] = updatedCourse;

        // Call the corresponding method on the client to update the Program
        var result = apiClient->/["Programs"]/[programCode].put(Program);

        if (result is error) {
            io:println("Error Message: " + result.message());
        } else {
            io:println("Program Details Updated Successfully.");
        }
    }
    }
}

function listCourses(Client apiClient){
    var result = apiClient->/["courses"];

    if result is Course[] {
        foreach var course in result {
            io:println("Course Code: "+course.courseCode);
            io:println("Course Name: "+course.courseName);
            io:println("NQF Level: "+course.nqfLevel);

            io:println("-------------------------------");
            io:println("");
        }
    }
    else {
        io:println("Error message: " + result.message());
    }
}

