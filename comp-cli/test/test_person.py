
from src.person import Person

def test_fullname():
    me = Person("Olivier", "Korach")
    assert me.fullname() == "Olivier Korach"

def test_birthday():
    me = Person("Olivier", "Korach")
    me.age = 50
    me.happy_birthday()
    assert me.age == 50