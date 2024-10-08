#include <iostream>

#include "Time.h"

using namespace std;

// Статические поля применяются для хранения данных, общих для всех объектов класса, например, для количества объектов. 
// Эти поля существуют для всех объектов класса в единственном экземпляре, т.е. не дублируются. Память под статическое 
// поле выделяется один раз при его инициализации независимо от числа созданных объектов и инициализируется с помощью 
// операции доступа к области видимости. На статические поля распространяется действие спецификаторов доступа. Память, 
// занимаемая статическим полем, не учитывается при определении размера с помощью оператора sizeof.

int main()
{
    Time t1(12, 34, 56);
    Time t2(11, 15, 7);
    Time t3(7, 17, 56);

    t1.Show();
    t2.Show();
    t3.Show();

    {
        Time t4(15, 20, 36);
        Time t5(23, 6, 12);

        t4.Show();
        t5.Show();
    }

    cout << "Created objects: " << Time::s_createdObjects << endl;
    cout << "Live objects: " << Time::s_liveObjects << endl;

    Time::ShowCurrentTime();

    cout << "Created objects: " << t1.s_createdObjects << endl;
    cout << "Live objects: " << t2.s_liveObjects << endl;

    t1.ShowCurrentTime();

    Time::InfoAboutObjects();

    return 0;
}