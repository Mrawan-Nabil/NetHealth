<?php

namespace App\Traits;

trait AvatarResolver
{
    /**
     * Resolve the avatar URL, providing a fallback UI-Avatar if necessary.
     */
    protected function resolveAvatarUrl(?string $avatar, string $name, string $background = '0D9488'): string
    {
        $fallback = 'https://ui-avatars.com/api/?name='.urlencode($name).'&background='.$background.'&color=fff';

        if (! $avatar) {
            return $fallback;
        }

        if (str_starts_with($avatar, 'http://') || str_starts_with($avatar, 'https://')) {
            if (str_contains($avatar, 'via.placeholder.com') || str_contains($avatar, 'placehold.co')) {
                return $fallback;
            }

            return $avatar;
        }

        return asset('storage/'.$avatar);
    }
}
