import ballerina/http;

# Represents an error
public type Error record {
    # Error code
    string code;
    # Error message
    string message;
};

# Represents a Program
public type Program record {
    # Program Code (Unique identifier)
    readonly string programCode;
    # NQF Level
    string nqfQual;
    # Faculty and Department Name
    string facultyAndDeptName;
    # Program Title
    string programTitle;
    # Registration Date
    string registrationDate;
    # List of Courses
    Course[] courses;
};

# Represents a course
public type Course record {
    # Course Code (Unique identifier)
    readonly string courseCode;
    # Course Name
    string courseName;
    # NQF Level
    string nqfLevel;
};

# Error response
public type ErrorResponse record {
    # Represents an error
    Error 'error;
};

# Bad request response
public type ValidationError record {|
    *http:BadRequest;
    # Error response.
    ErrorResponse body;
|};

# Represents headers of created response
public type LocationHeader record {|
    # Location header. A link to the created resource.
    string location;
|};

# Resource Created response
public type ResourceCreated record {|
    *http:Created;
    # Location header representing a link to the created resource.
    LocationHeader headers;
|};

# Resource updated response
public type ResourceUpdated record {|
    *http:Ok;
|};

# Tables for storing Programs & Courses
table<Program> key(programCode) ProgramsTable = table [];
table<Course> key(courseCode) courseTable = table [];

service / on new http:Listener(8080) {

    # + return - Add a new Programs
    resource function post Programs(@http:Payload Program Program) returns ResourceCreated|ValidationError {
        
        //Validate Program information
        if (!isValidProgram(Program)) {
            return <ValidationError>{
                body: {
                    'error: {
                        code: "INVALID_DATA",
                        message: "Invalid Program data"
                    }
                }
            };
        }

        //Add Program to table after successfull validation
        _= ProgramsTable.add(Program);        

        //Return successfull response
        string ProgramUrl = string `/Programs/${Program.programCode}`;
        return <ResourceCreated>{
            headers: {
                location: ProgramUrl
            }
        };
    }
# + return - Delete a Programs record by their Program code
    resource function delete Programs/[string programCode]() returns Program|ValidationError {
        if (ProgramsTable.hasKey(programCode)) {
            Program removed = ProgramsTable.remove(programCode);
            return removed;
        } else {
            return <ValidationError>{
                body: {
                    'error: {
                        code: "Program_NOT_FOUND",
                        message: "Program not found"
                    }
                }
            };
        }
    }
    # + return - Retrieve a list of all Programs
    resource function get Programs() returns Program[] {
        return ProgramsTable.toArray();
    }

    # + return - Retrieve the details of a specific Program by their Program number
    resource function get Programs/[string programCode]() returns Program?|ValidationError {
        if (ProgramsTable.hasKey(programCode)) {
            Program foundProgram = ProgramsTable.get(programCode);
            return foundProgram;
        } else {
            return <ValidationError>{
                body: {
                    'error: {
                        code: "Program_NOT_FOUND",
                        message: "Program not found"
                    }
                }
            };
        }
    }
    # + return - Retrieve all the Programs that have the same NQF Level
    resource function get Programs/office/[string nqfQual]() returns Program[] {
        Program[] ProgramsInOffice = [];
        foreach var Program in ProgramsTable {
            if (Program.nqfQual == nqfQual) {
                ProgramsInOffice.push(Program);
            }
        }
        return ProgramsInOffice;
    }
    # + return - Add a new course
    resource function post courses(@http:Payload Course course) returns ResourceCreated|ValidationError {
        if (!isValidNewCourse(course)) {
            return <ValidationError>{
                body: {
                    'error: {
                        code: "INVALID_DATA",
                        message: "Invalid course data"
                    }
                }
            };
        }

        _= courseTable.add(course);
        string courseUrl = string `/courses/${course.courseCode}`;
        return <ResourceCreated>{
            headers: {
                location: courseUrl
            }
        };
    }
    # + return - Retrieve a list of all courses
    resource function get courses() returns Course[] {
        return courseTable.toArray();
        }

    # + return - Retrieve the details of a specific course by its course code
    resource function get courses/[string courseCode]() returns Course?|ValidationError {
        if (courseTable.hasKey(courseCode)) {
            Course requestedCourse = courseTable.get(courseCode);
            return requestedCourse;
        } else {
            return <ValidationError>{
                body: {
                    'error: {
                        code: "COURSE_NOT_FOUND",
                        message: "Course not found"
                    }
                }
            };
        }
    }

    # + return - Update an existing Program information
    resource function put Programs/[string programCode](@http:Payload Program Program) returns ResourceUpdated|ValidationError {
        // Check if provided Program Code exists
        if (!ProgramsTable.hasKey(programCode)) {
            return <ValidationError>{
                body: {
                    'error: {
                        code: "Program_NOT_FOUND",
                        message: "Program not found"
                    }
                }
            };
        }

        // Validate provided Program data
        if (!isValidProgram(Program)) {
            return <ValidationError>{
                body: {
                    'error: {
                        code: "INVALID_DATA",
                        message: "Invalid Program data"
                    }
                }
            };
        }

        ProgramsTable.put(Program);
        
        return <ResourceUpdated>{};
    }
    # + return - Delete a course by its course code
    resource function delete courses/[string courseCode]() returns Course|ValidationError {
        if (courseTable.hasKey(courseCode)) {
            Course removed = courseTable.remove(courseCode);
            return removed;
        } else {
            return <ValidationError>{
                body: {
                    'error: {
                        code: "COURSE_NOT_FOUND",
                        message: "Course not found"
                    }
                }
            };
        }
    }
}

function isValidProgram(Program Program)  returns boolean {
    // Check if the programCode is unique
    if(ProgramsTable.hasKey(Program.programCode)){
        return false;
    }

    // Check if all required fields are present and not empty
    if(Program.programCode == "" || Program.facultyAndDeptName == "" || Program.courses.length() == 0 || Program.nqfQual == "" || Program.programTitle == ""|| Program.registrationDate == ""){
        return false;
    }

    // Check if provided course codes for new Program exists in Course map
    foreach var course in Program.courses {
        if(!courseTable.hasKey(course.courseCode)){
            return false;
        }
    }

    return true; 
}

function isValidNewCourse(Course course) returns boolean {
    // Check if the courseCode is unique
    if(courseTable.hasKey(course.courseCode)){
        return false;
    }

    return true; 
}
