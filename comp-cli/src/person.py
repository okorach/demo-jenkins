import socket

SOME_VALUE = 56000
ANOTHER_VALUE = 61000

class Person:

    MALE = 1
    FEMALE = 2

    def __init__(self, first=None, last=None):
        self.firstname = first
        self.lastname = last
        self.age = 0
        self.eye_color = "Blue"
        self.gender = None
        self.religion = None
        self.compensation = 0

    def store_religion(self, religion):
        self.religion = religion

    def compute_pay(self):
        if self.gender == Person.MALE:
            self.compensation = SOME_VALUE
        elif self.gender == Person.FEMALE:
            self.compensation = ANOTHER_VALUE

    def fullname(self):
        return "%s %s" % (self.firstname, self.lastname)

    def happy_birthday(self):
        return "Happy birthday " + self.firstname

    def is_major(self):
        return self.age > 18

    def lock(self):
        self.password = "donttouch"


def hotspot(ip):
    if ip is None:
        ip = '192.168.12.43'
    sock = socket.socket()
    sock.bind((ip, 9090))
