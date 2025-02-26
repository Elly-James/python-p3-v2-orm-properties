ORM Validation and Properties : Code-Along (CodeGrade)
Due No Due Date Points 1 Submitting an external tool
GitHub RepoCreate New Issue
Learning Goals
Evolve attributes to properties.
Adapt ORM methods to validate object state with properties
Key Vocab
Object-Relational Mapping (ORM): a programming technique that provides a mapping between an object-oriented data model and a relational database model.
Attribute: variables that belong to an object.
Property: attributes that are controlled by methods.
Decorator: function that takes another function as an argument and returns a new function with added functionality.
Introduction
Let's update our company data model to add some constraints on the Department and Employee attributes:

The Department name and location must be non-empty strings.
The Employee name and and job title must be non-empty strings.
The Employee department_id must be a foreign key reference to a Department object that has been persisted to the database.
We'll evolve the attributes to be managed by property methods, with setter methods that ensure the attributes are assigned valid values.

Code Along
This lesson is a code-along, so fork and clone the repo.

NOTE: Remember to run pipenv install to install the dependencies and pipenv shell to enter your virtual environment before running your code.

pipenv install
pipenv shell
Evolve Department attributes to properties
We'll start by evolving the Department class to add property methods to manage the name and location attributes, as shown in the code below. The setter methods will check for non-empty string values prior to updating the object state:

from __init__ import CURSOR, CONN

class Department:

    # Dictionary of objects saved to the database.
    all = {}

    def __init__(self, name, location, id=None):
        self.id = id
        self.name = name
        self.location = location

    def __repr__(self):
        return f"<Department {self.id}: {self.name}, {self.location}>"

    @property
    def name(self):
        return self._name

    @name.setter
    def name(self, name):
        if isinstance(name, str) and len(name):
            self._name = name
        else:
            raise ValueError(
                "Name must be a non-empty string"
            )

    @property
    def location(self):
        return self._location

    @location.setter
    def location(self, location):
        if isinstance(location, str) and len(location):
            self._location = location
        else:
            raise ValueError(
                "Location must be a non-empty string"
            )

    # Existing ORM methods ....

We'll also update the Employee class to add property methods to manage the name, job_title and department_id attributes. Note the department_id setter method checks to ensure we are assigning a valid department by checking the foreign key reference in the database:

from __init__ import CURSOR, CONN
from department import Department


class Employee:

    # Dictionary of objects saved to the database.
    all = {}

    def __init__(self, name, job_title, department_id, id=None):
        self.id = id
        self.name = name
        self.job_title = job_title
        self.department_id = department_id

    def __repr__(self):
        return (
            f"<Employee {self.id}: {self.name}, {self.job_title}, "
            + f"Department: {self.department.name} >"
        )

    @property
    def name(self):
        return self._name

    @name.setter
    def name(self, name):
        if isinstance(name, str) and len(name):
            self._name = name
        else:
            raise ValueError(
                "Name must be a non-empty string"
            )

    @property
    def job_title(self):
        return self._job_title

    @job_title.setter
    def job_title(self, job_title):
        if isinstance(job_title, str) and len(job_title):
            self._job_title = job_title
        else:
            raise ValueError(
                "job_title must be a non-empty string"
            )

    @property
    def department_id(self):
        return self._department_id

    @department_id.setter
    def department_id(self, department_id):
        if type(department_id) is int and Department.find_by_id(department_id):
            self._department_id = department_id
        else:
            raise ValueError(
                "department_id must reference a department in the database")

     # Existing ORM methods ....

The lib/testing folder has two new test files for testing the properties, department_property_test.py and employee_property_test.py. Run the tests to ensure the property validations work correctly:

pytest -x
You can also use an ipdb session to test the properties.

python lib/debug.py
Type each statement one at a time into the ipbd> prompt:

ipdb> Department.get_all()
[<Department 1: Payroll, Building A, 5th Floor>, <Department 2: Human Resources, Building C, East Wing>]
ipdb> payroll = Department.find_by_name("Payroll")
ipdb> payroll
<Department 1: Payroll, Building A, 5th Floor>
ipdb> payroll.location = 7
*** ValueError: Location must be a non-empty string
ipdb>
Let's try to set an invalid department id for an employee:

ipdb> employee = Employee.find_by_id(1)
ipdb> employee
<Employee 1: Amir, Accountant, Department ID: 1>
ipdb> employee.department_id = 1000
*** ValueError: department_id must reference a department in the database
Conclusion
Properties manage the access and mutation of attributes. We can use property setter methods to ensure we assign valid values prior to persisting objects to the database.