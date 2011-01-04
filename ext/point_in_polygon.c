#include "ruby.h"


int pip(double poly[][2], int npoints, double xt, double yt)
{
    double xnew, ynew;
    double xold, yold;
    double x1, y1;
    double x2, y2;
    int i;
    int inside = 0;

    if (npoints < 3) {
        return 0;
    }

    xold = poly[npoints-1][0];
    yold = poly[npoints-1][1];

    for (i = 0; i < npoints; i++) {
        xnew = poly[i][0];
        ynew = poly[i][1];

        if (xnew > xold) {
            x1 = xold;
            x2 = xnew;
            y1 = yold;
            y2 = ynew;
        } else {
            x1 = xnew;
            x2 = xold;
            y1 = ynew;
            y2 = yold;
        }

        if ((xnew < xt) == (xt <= xold) &&      /* edge "open" at left end */
            (yt - y1) * (x2 - x1) <
            (y2 - y1) * (xt - x1))
        {
            inside = !inside;
        }

        xold = xnew;
        yold = ynew;
    }

    return inside;
}


static VALUE t_point_in_polygon(VALUE self, VALUE polygon, VALUE p_x, VALUE p_y)
{
    /* ensure `p_x` and `p_y` are floats */
    Check_Type(p_x, T_FLOAT);
    Check_Type(p_y, T_FLOAT);

    /* ensure `polygon` is an array with at least 3 points */
    Check_Type(polygon, T_ARRAY);
    VALUE *poly_arr = RARRAY_PTR(polygon);
    int poly_len = RARRAY_LEN(polygon);
    if (poly_len < 3) {
        rb_raise(rb_eTypeError, "Polygon must have at least 3 points");
    }

    /* convert `p_x` and `p_y` to doubles */
    double x = NUM2DBL(p_x);
    double y = NUM2DBL(p_y);

    /* convert `polygon` to C array */
    double *p_polygon = ALLOCA_N(double, 2 * poly_len);

    int i = 0;
    for (i = 0; i < poly_len; i++) {
        Check_Type(poly_arr[i], T_ARRAY);
        VALUE *p = RARRAY_PTR(poly_arr[i]);
        int p_len = RARRAY_LEN(poly_arr[i]);
        if (p_len != 2) {
            rb_raise(rb_eTypeError, "All points in polygon must have two floats");
        }
        Check_Type(p[0], T_FLOAT);
        Check_Type(p[1], T_FLOAT);
        p_polygon[i*2] = NUM2DBL(p[0]);
        p_polygon[(i*2)+1] = NUM2DBL(p[1]);
    }

    /* call point-in-polygon algorithm */
    int res = pip((double (*)[2]) p_polygon, poly_len, x, y);

    if (res) {
        return Qtrue;
    } else {
        return Qfalse;
    }
}


void Init_point_in_polygon() {
    VALUE cPip = rb_define_module("PointInPolygon");
    rb_define_module_function(cPip, "point_in_polygon?", t_point_in_polygon, 3);
}

