import re
import math
import sys
from collections import Counter

def get_operators_and_operands(code):
    code = re.sub(r"//.*?$|/\*.*?\*/|'''[\s\S]*?'''|\"\"\"[\s\S]*?\"\"\"|'[^']*'|\"[^\"]*\"", '', code, flags=re.MULTILINE | re.DOTALL)
    code = re.sub(r'^\s*(import|export|part)\s+.*?;', '', code, flags=re.MULTILINE)
    code = re.sub(r'@\w+\b', '', code)
    operators = set([
        '+', '-', '*', '/', '%', '++', '--',
        '==', '!=', '>', '<', '>=', '<=',
        '&&', '||', '!', '~', '&', '|', '^', '<<', '>>',
        '=', '+=', '-=', '*=', '/=', '%=', '&=', '|=', '^=', '<<=', '>>=',
        '?', ':', '?.', '??', '??=', '=>', '->', '..',
    ])
    keywords_types = set([
        'if', 'else', 'for', 'while', 'do', 'switch', 'case', 'default', 'break', 'continue', 'return', 'throw', 'try', 'catch', 'finally', 'new', 'const', 'final', 'var', 'static', 'void', 'this', 'super', 'extends', 'implements', 'with', 'abstract', 'class', 'enum', 'typedef', 'import', 'export', 'library', 'part', 'of', 'in', 'on', 'assert', 'await', 'yield', 'sync', 'async', 'get', 'set', 'required', 'late', 'covariant', 'external', 'factory', 'mixin', 'operator', 'show', 'hide', 'deferred', 'native', 'Function', 'dynamic', 'Map', 'List', 'Set', 'bool', 'int', 'double', 'String', 'Null', 'Object', 'Future', 'Stream', 'Iterable', 'Iterator', 'Symbol', 'Type', 'Never', 'true', 'false', 'null'
    ])
    punctuation_ops = ['\\(', '\\)', '\\[', '\\]', '\\{', '\\}', ',', ';', '\\.', '@']
    operator_pattern = r'(\?\?.|\?\.|\?\?|\?\?=|\+=|-=|\*=|/=|%=|&=|\|=|\^=|<<=|>>=|==|!=|>=|<=|&&|\|\||<<|>>|--|\+\+|=>|->|\.\.|[+\-*/%&|^!~<>=?:])'
    punctuation_pattern = '|'.join(punctuation_ops)
    scanner = re.Scanner([
        (r'[A-Za-z_][A-Za-z0-9_]*', lambda s, t: ('IDENT', t)),
        (r'\d+\.\d+', lambda s, t: ('NUMBER', t)),
        (r'\d+', lambda s, t: ('NUMBER', t)),
        (operator_pattern, lambda s, t: ('OP', t)),
        (punctuation_pattern, lambda s, t: ('OP', t)),
        (r'\s+', None),
        (r'.', lambda s, t: ('UNKNOWN', t)),
    ])
    results, remainder = scanner.scan(code)
    op_counter = Counter()
    operand_counter = Counter()
    for kind, t in results:
        if kind == 'IDENT' and t not in keywords_types:
            operand_counter[t] += 1
        elif kind == 'NUMBER':
            operand_counter[t] += 1
        elif kind == 'OP' and t in operators:
            op_counter[t] += 1
    if __name__ == '__main__' and len(sys.argv) == 2 and sys.argv[1].endswith('accelerometer_module.dart'):
        print('TOKENS:', results)
    if remainder:
        print(f'Warning: Unparsed code: {remainder[:100]}...')
    return op_counter, operand_counter

def halstead_metrics(op_counter, operand_counter):
    n1 = len(op_counter)
    n2 = len(operand_counter)
    N1 = sum(op_counter.values())
    N2 = sum(operand_counter.values())
    n = n1 + n2
    N = N1 + N2
    if n == 0 or N == 0:
        return None
    V = N * math.log2(n) if n > 0 else 0
    D = (n1 / 2) * (N2 / n2) if n2 > 0 else 0
    E = V * D
    return {
        'n1 (unique operators)': n1,
        'n2 (unique operands)': n2,
        'N1 (total operators)': N1,
        'N2 (total operands)': N2,
        'Vocabulary (n)': n,
        'Length (N)': N,
        'Volume (V)': V,
        'Difficulty (D)': D,
        'Effort (E)': E
    }

def main():
    if len(sys.argv) != 2:
        print('Usage: python halstead_dart.py <dart_file>')
        sys.exit(1)
    with open(sys.argv[1], 'r') as f:
        code = f.read()
    op_counter, operand_counter = get_operators_and_operands(code)
    metrics = halstead_metrics(op_counter, operand_counter)
    if metrics:
        for k, v in metrics.items():
            print(f'{k}: {v}')
    else:
        print('Not enough data to calculate Halstead metrics.')

if __name__ == '__main__':
    main()
