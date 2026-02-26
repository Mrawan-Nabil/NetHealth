<?php

namespace App\Rules;

use Closure;
use Illuminate\Contracts\Validation\DataAwareRule;
use Illuminate\Contracts\Validation\ValidationRule;

class ValidNationalId implements DataAwareRule, ValidationRule
{
    protected $data = [];

    // This allows the rule to see other fields like 'date_of_birth'
    public function setData(array $data): self
    {
        $this->data = $data;

        return $this;
    }

    public function validate(string $attribute, mixed $value, Closure $fail): void
    {
        // 1. Basic format check
        if (! preg_match('/^[23][0-9]{13}$/', $value)) {
            $fail('National ID must be 14 digits and start with 2 or 3.');

            return;
        }

        // 2. Extract Date Parts
        $centuryDigit = (int) $value[0];
        $century = ($centuryDigit === 2) ? 1900 : 2000;

        $year = $century + (int) substr($value, 1, 2);
        $month = (int) substr($value, 3, 2);
        $day = (int) substr($value, 5, 2);

        // 3. Check if the date is valid (e.g., no Feb 31st)
        if (! checkdate($month, $day, $year)) {
            $fail('The National ID contains an invalid date of birth.');

            return;
        }

        // 4. Cross-verify with the date_of_birth field (Optional but Recommended)
        $idDateString = sprintf('%04d-%02d-%02d', $year, $month, $day);
        $inputDate = $this->data['date_of_birth'] ?? null;

        if ($inputDate && $idDateString !== date('Y-m-d', strtotime($inputDate))) {
            $fail('The National ID does not match the selected Date of Birth.');
        }
    }
}
