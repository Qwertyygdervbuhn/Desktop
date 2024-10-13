#include<iostream>
#include<time.h>
using namespace std;

class Point
{
	//private:
	int x;
	int y;
	int z;
public:
	Point()
	{
		cout << "Construct\n";
		x = y = 0;
	}
	Point(int x1) 
	{
		cout << "construct X\n"; 
		x = x1;		
	}
	Point(int x1, int y1):Point(x1)
	{
		cout << "construct Y\n";
		y = y1;
	}
	Point(int x1, int y1, int z1):Point(x1,y1) // главный конструктор(делегирует задачи, перенаправл€ет по другим конструкторам)
	{
		cout << "construct Z\n";
		z = z1;
	}
	void Output()
	{
		cout << "X: " << x << "\tY: " << y << endl;
	}

	//////  методы аксессоры

	int GetX()const  // инспекторы
	{
		// x = -100; // ошибка 
		return x;
	}

	int GetY()const
	{
		return y;
	}

	int GetZ()const
	{
		return z;
	}

	/////  ћодификаторы 
	void SetX(int X)
	{
		// X <100
		if (X > 100)
		{
			cout << "Error\n";
			x = 0;
		}
		else
		{
			x = X;
		}
	}
};
/*
—интаксис делегировани€:
»м€_класса ( параметры (формальные) ) : им€_класса ( формальна€ передача параметров )
{
тело;
};

*/

void main()
{
	Point obj1(10, 20, 30);
	cout << obj1.GetX()<< endl;

	obj1.SetX(1000);
		cout << obj1.GetX() << endl;
		obj1.SetX(25);
		cout << obj1.GetX() << endl;



	system("pause");
}