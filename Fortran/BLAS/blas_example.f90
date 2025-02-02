program blas_example

    ! Parameter defining double precision
    integer, parameter :: DP = kind(1.0D0)

    ! Matrix sizes
    integer, parameter :: M = 1100
    integer, parameter :: N = 1200
    integer, parameter :: K = 1300

    ! Matrices
    real(DP), dimension(:,:), allocatable :: A, B, C

    ! Scale parameters used by dgemm (set to 1 in this example)
    real(DP), parameter :: alpha = 1.0D0
    real(DP), parameter :: beta  = 1.0D0

    ! Arguments indicating wether A or B should be transposed
    character(1), parameter :: transA = 'N'
    character(1), parameter :: transB = 'N'

    ! Loop variables
    integer :: i, j

    ! Variables for keeping track of time
    real(DP) :: tic, toc

    ! Allocate matrices
    allocate(A(M, K))
    allocate(B(K, N))
    allocate(C(M, N))

    ! Fill arrays with numbers
    do i = 1, M
        do j = 1, K
            A(i,j) = j + (i-1)*K
        end do
    end do
    do i = 1, K
        do j = 1, N
            B(i,j) = j + (i-1)*N
        end do
    end do

    ! Do matrix calculation the naïve way, with for loops
    call cpu_time(tic)
    do i = 1, M
        do j = 1, N
           C(i,j) = sum(A(i,:) * B(:,j))
        end do
    end do
    call cpu_time(toc)
    print*, 'Naïve matrix multiplication took ', toc - tic, ' seconds'

    ! Reset c to zeros
    C = 0.0D0

    call cpu_time(tic)
    call dgemm(transA, transB, M, N, K, alpha, A, M, B, K, beta, C, M)
    call cpu_time(toc)
    print*, 'Call to dgemm(...) took ', toc - tic, ' seconds'

end program blas_example
