part of query.compose;

String composeAnd(final And and) => and.expressions.map((Expression exp) {
      final sb = new StringBuffer();

      if (exp.length != 1) {
        sb.write('(');
      }

      sb.write(composeExpression(exp));

      if (exp.length != 1) {
        sb.write(')');
      }

      return sb.toString();
    }).join(' AND ');

String composeOr(final Or or) => or.expressions.map((Expression exp) {
      StringBuffer sb = new StringBuffer();

      if (exp.length != 1) {
        sb.write('(');
      }

      sb.write(composeExpression(exp));

      if (exp.length != 1) {
        sb.write(')');
      }

      return sb.toString();
    }).join(' OR ');

String composeExpression(final Expression exp) {
  if (exp is Or) {
    return composeOr(exp);
  } else if (exp is And) {
    return composeAnd(exp);
  } else if (exp is Cond) {
    return '${composeField(exp.lhs)} ${exp.op.string} ${composeValue(exp.rhs)}';
  } else if (exp is CondCol) {
    return '${composeField(exp.lhs)} ${exp.op.string} ${composeField(exp.rhs)}';
  } else if (exp is Between) {
    return '(${composeField(exp.field)} BETWEEN ${composeValue(exp.low)} AND ${composeValue(exp.high)})';
  } else if (exp is InBetweenCol) {
    return '(${composeField(exp.field)} BETWEEN ${composeField(exp.low)} AND ${composeField(exp.high)})';
  } else {
    throw new Exception('Unknown expression ${exp.runtimeType}!');
  }
}

String composeField(final Field col) =>
    (col.tableName != null ? col.tableName + '.' : '') + col.name;
