#include <iostream>
#include <support_at/Point2D.h>

using namespace support_at;

Point2D_d::Point2D_d() : m_x(0.0),
			 m_y(0.0)
{
}

Point2D_d::Point2D_d(double x, double y) : m_x(x),
				       m_y(y)
{
}

// std::ostream& operator<<(std::ostream& os,
// 			 const Point2D_d& pt)
// {
//     os << "x: " << pt.m_x << ", y: " << pt.m_y;
//     return os;
// }
