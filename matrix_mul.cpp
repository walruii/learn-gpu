#include <array>
#include <iostream>
#include <vector>
using namespace std;

void matrix_mul_2x2(const array<int, 4> a, const array<int, 4> b,
                    array<int, 4> &c) {
  c[0] = a[0] * b[0] + a[1] * b[2];
  c[1] = a[0] * b[1] + a[1] * b[3];
  c[2] = a[2] * b[0] + a[3] * b[2];
  c[3] = a[2] * b[1] + a[3] * b[3];
}

void matrix_mul_rec(const vector<int> &A, int rowA, int colA,
                    const vector<int> &B, int rowB, int colB, vector<int> &C,
                    int rowC, int colC, int n, int N_total) {
  if (n == 2) {
    array<int, 4> a = {A[rowA * N_total + colA], A[rowA * N_total + colA + 1],
                       A[(rowA + 1) * N_total + colA],
                       A[(rowA + 1) * N_total + colA + 1]};
    array<int, 4> b = {B[rowA * N_total + colA], B[rowA * N_total + colA + 1],
                       B[(rowA + 1) * N_total + colA],
                       B[(rowA + 1) * N_total + colA + 1]};
    array<int, 4> c = {0, 0, 0, 0};
    matrix_mul_2x2(a, b, c);
    C[rowC * N_total + colC] = c[0];
    C[rowC * N_total + colC + 1] = c[1];
    C[(rowC + 1) * N_total + colC] = c[2];
    C[(rowC + 1) * N_total + colC + 1] = c[3];
    return;
  }
  int half = n / 2;

  // 1st half
  matrix_mul_rec(A, rowA, colA, B, rowB, colB, C, rowC, colC, half, N_total);
  matrix_mul_rec(A, rowA, colA + half, B, rowB + half, colB, C, rowC, colC,
                 half, N_total);

  // 2nd half
  matrix_mul_rec(A, rowA, colA, B, rowB, colB + half, C, rowC, colC + half,
                 half, N_total);
  matrix_mul_rec(A, rowA, colA + half, B, rowB, colB + half, C, rowC,
                 colC + half, half, N_total);

  // 3rd half
  matrix_mul_rec(A, rowA + half, colA, B, rowB, colB, C, rowC + half, colC,
                 half, N_total);
  matrix_mul_rec(A, rowA + half, colA + half, B, rowB + half, colB, C,
                 rowC + half, colC, half, N_total);

  // 4th half
  matrix_mul_rec(A, rowA + half, colA, B, rowB, colB + half, C, rowC + half,
                 colC + half, half, N_total);
  matrix_mul_rec(A, rowA + half, colA + half, B, rowB + half, colB + half, C,
                 rowC + half, colC + half, half, N_total);
}

int main() {
  constexpr int N = 4;

  vector<int> a(N * N, 2);
  vector<int> b(N * N, 2);
  vector<int> c(N * N);

  matrix_mul_rec(a, 0, 0, b, 0, 0, c, 0, 0, N, N);

  cout << "Matrix Multiplication" << endl;
  for (int i = 0; i < N; ++i) {
    cout << "| ";
    for (int j = 0; j < N; ++j) {
      cout << c[i * N + j] << " ";
    }
    cout << "|" << endl;
  }
  return 0;
}
