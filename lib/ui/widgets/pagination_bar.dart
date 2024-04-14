import 'package:flutter/material.dart';
import 'package:test_task/core/app_constants.dart';

class PaginationBar extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final Function(int) onPageChange;

  const PaginationBar({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onPageChange,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        totalPages + 1,
        (index) {
          if (index == totalPages) {
            return InkWell(
              onTap: currentPage < totalPages
                  ? () => onPageChange(currentPage + 1)
                  : null,
              child: Icon(
                Icons.arrow_forward,
                color: currentPage < totalPages ? Colors.black : Colors.grey,
              ),
            );
          } else {
            // Номера страниц
            return InkWell(
              onTap: () => onPageChange(index + 1),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                margin: const EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: index + 1 == currentPage
                        ? AppConstants.backgroundColor
                        : Colors.transparent, // Цвет бордера
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  '${index + 1}',
                  style: TextStyle(
                    color: index + 1 == currentPage
                        ? AppConstants.backgroundColor
                        : null,
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
